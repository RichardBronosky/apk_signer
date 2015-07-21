config_file=config.ini

# function to parse the ini style configuration file
config_parser(){
	local iniFile="$1";
	local tmpFile=$( mktemp /tmp/`basename $iniFile`.XXXXXX );
	local binSED=$( which sed );

	# remove tabs or spaces around the =
	$binSED -e 's/[ \t]*=[ \t]*/=/g;$a\
}' $iniFile > $tmpFile;

	# transform section labels into function declaration
	$binSED -i -e 's/\[\([A-Za-z0-9_.]*\)\]/config.section.\1() \{/g' $tmpFile;
	$binSED -E -i -e '/^[^#]+=/,$s/config\.section\./\}\'$'\nconfig\.section\./g' $tmpFile;

	# now load the file
	source $tmpFile;

	# clean up
	rm -f $tmpFile;
}

package_name(){
    aapt dump badging "$1" | awk -v FS="'" '/package: name=/{print $2}'
}

sign_align(){
    jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore "$keystore" -storepass "$storepass" -keypass "$keypass" -signedjar "$name_signed" "$f" "$alias";
    zipalign -f -v 4 "$name_signed" "$name_aligned";
}

# These 2 cd commands allow $config_file to be relative to the path of this script
cd $(dirname $(readlink ./apk_signer.sh || echo ./apk_signer.sh))
config_parser $config_file
cd -

for f in "$@"; do
    name_package=$(package_name "$f");
    name_dir=$(dirname "$f");
    name_file=$(basename "$f");
    name_signed="signed.$name_file";
    name_aligned="aligned.$name_signed";
    config.section.$name_package || { echo "Could not locate $name_package in config file: $config_file"; exit; }
    # This cd command make files be created in the same location as the source, otherwise in the current directory.
    #cd "$name_dir";
    sign_align;
    # Keeping the signed file is confusing since you can only submit the aligned file.
    rm "$name_signed"
done
