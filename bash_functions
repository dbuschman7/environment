# A bunch of bash functions that I find useful for various purposes
#
# DEPENDS ON ack-grep... you're welcome.  At least on Ubuntu/Mint it is ack-grep.  On OSX homebrew it is just ack

# cd up to a certain directory name
cb() {
    pushd `pwd | sed -r "s/($1).*/\\1/"`
}

_find_file_w_extension() {
    find . -type f -name $1
}

# find all scala files from the current directory
scala_files() {
    _find_file_w_extension "*.scala"
}

# find all groovy files from the current directory
groovy_files() {
    _find_file_w_extension "*.groovy"
}

# find all java files from the current directory
java_files() {
    _find_file_w_extension "*.java"
}

_grepit() {
    xargs ack-grep --color $1
}

_find_whatev() {
    if [ $3 ]
    then
        $1 | grep -v $3 | _grepit $2
    else
        $1 | _grepit $2
    fi
}

_find_whatev_i() {
    if [ $3 ]
    then
        $1 | grep -v $3 | _grepit -i $2
    else
        $1 | _grepit -i $2
    fi
}

# finds a given string in scala files
# fs <token to find> [filter word(s)]
# fs SshClient "Test\|sandbox"
fs() {
	_find_whatev scala_files $1 $2
}

# finds a given string in scala files (case-insensitive)
fsi() {
	_find_whatev_i scala_files $1 $2
}

# finds a given string in any file
fa() {
	find . -type f | _grepit $1
}

# finds a given string in any file (case-insensitive)
fai() {
    find . -type f | _grepit -i $1
}

# finds a scala file with the given string in its name (case-insensitive)
fsf() {
	scala_files | grep -i $1
}

# finds a given string in groovy files
fgr () {
	_find_whatev groovy_files $1 $2
}

# finds a given string in groovy files (case-insensitive)
fgri () { # find groovy :( case-insensitive
	_find_whatev_i groovy_files $1 $2
}

# finds a given string in java files
fj() {
	_find_whatev java_files $1 $2
}

# finds a given string in java files (case-insensitive)
fji() { # find java 
	_find_whatev_i java_files $1 $2
}

# find jar in ivy cache (case-insensitive)
fjar() {
	find ~/.ivy2/cache/ -iname "$@.jar"
}

# find jar in ivy cache containing a class name with the given string (case-insensitive)
fclass() {
	find ~/.ivy2/cache/ -name "*.jar" -exec grep -il --color "$@" {} \;
}

# find a file name containing the given string
ff() {
	find . -type f -iname "*$1*"
}

# prints the manifest of the given jar
manifest() {
	unzip -p "$@" META-INF/MANIFEST.MF
}
