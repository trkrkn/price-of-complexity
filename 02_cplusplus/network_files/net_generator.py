# -*- coding: utf-8 -*-
#!/usr/bin/pythonw

import sys
import os

in_subdirectory 	= sys.argv[1]
in_directory 		= os.getcwd() + '/' + in_subdirectory

out_subdirectory 	= in_directory.replace('buy','sell')
out_directory 		= os.getcwd() + '/' + out_subdirectory

all_files 		= os.listdir(in_directory)
all_data_files 	= [file_name for file_name in all_files if 'buy' in file_name]

for file_name in all_data_files:
	print file_name
	in_file = open (in_directory + '/' + file_name,'rU')
	buy_data = in_file.readlines()
	sell_data = []
	print buy_data
	if isinstance(buy_data[0],list): 
		for line in buy_data:
			tmp_line = line.split(',')
			print tmp_line
			new_line = [tmp_line[1], tmp_line[0], tmp[2]]
			print line
			print new_line
			print "\n"
	else:
			print buy_data
			# tmp_line = buy_data.split(',')
			print tmp_line
			new_line = [tmp_line[1], tmp_line[0], tmp[2]]
			print line
			print new_line
			print "\n"	