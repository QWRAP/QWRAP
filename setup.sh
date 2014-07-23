echo "This command will find the absolute path of QWRAP and add it to file ~/.bashrc"
echo -e "export PATH=\${PATH}:$PWD/" >> ~/.bashrc
source ~/.bashrc

echo "Done"

