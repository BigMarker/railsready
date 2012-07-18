#!/bin/bash
#
# Rails Ready
#
# Author: Josh Frye <joshfng@gmail.com>
# Licence: MIT
#
# Contributions from: Wayne E. Seguin <wayneeseguin@gmail.com>
# Contributions from: Ryan McGeary <ryan@mcgeary.org>
#

ruby_version=$1
ruby_version_string=$2
ruby_source_url=$3
ruby_source_tar_name=$4
ruby_source_dir_name=$5
whichRuby=$6 # 1=source 2=RVM
script_runner=$(whoami)
railsready_path=$7
log_file=$8

#echo "vars set: $ruby_version $ruby_version_string $ruby_source_url $ruby_source_tar_name $ruby_source_dir_name $whichRuby $railsready_path $log_file"

echo -e "\nInstalling OS X developer tools..."
case `sw_vers | grep 'ProductVersion:' | cut -f 2` in                                                                     
	*10.7* ) echo "downloading OS X developer tools"; curl -L -O http://github.com/downloads/kennethreitz/osx-gcc-installer/GCC-10.7-v2.pkg; sudo installer -pkg "./GCC-10.7-v2.pkg" -target /;;
	*10.6* ) echo "downloading OS X developer tools"; curl -L -O http://github.com/downloads/kennethreitz/osx-gcc-installer/GCC-10.6.pkg; sudo installer -pkg "./GCC-10.6.pkg" -target /;;
	* ) echo "Please upgrade your system to at least Snow Leopard 10.6!";;          
esac
echo "==> done..."

echo -e "\nInstalling Homebrew"
/usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/1209017)" >> $log_file 2>&1
echo "==> done..."

# Install wget
echo -e "\n=> Updating wget..."
brew install wget >> $log_file 2>&1
echo "==> done..."

# Install git-core
echo -e "\n=> Updating git..."
brew install git >> $log_file 2>&1
echo "==> done..."

# Install imagemagick
echo -e "\n=> Installing imagemagick (this may take a while)..."
brew install imagemagick >> $log_file 2>&1
echo "==> done..."

# Install MySQL
echo -e "\n=> Installing MySQL (this may take a while)..."
brew install mysql >> $log_file 2>&1
unset TMPDIR >> $log_file 2>&1
mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp >> $log_file 2>&1
launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist >> $log_file 2>&1
mkdir -p ~/Library/LaunchAgents >> $log_file 2>&1
cp /usr/local/Cellar/mysql/5.5.25/homebrew.mxcl.mysql.plist ~/Library/LaunchAgents/ >> $log_file 2>&1
mysql.server start
echo "==> done..."
