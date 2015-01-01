=begin
ハッシュはkeyが同じものの場合、後から来たvalueで上書きされるという性質を持つ。
よって、md5をキーに、場所をvalueにしたハッシュを作り　#1
場所をキーに、md5をvalueにしたハッシュを作る。 #2

その後、#1をinvertしたものと#2を配列にし、引き算を行えば良い。


=end


#指定された位置からのファイル名を再帰的に取得する。
require 'digest/md5'

class CleanTool
	
	def initialize
		@file_data={}
		@file_data_hikumono={}
		@zyohuku_utagai=[]
		@zyohuku_kakutei_file=[]
		@zyohuku_kakutei_data=[]
		@dir_list=[]
		@sum_size=0
	end
	def main
		puts "取得するデータの位置を入力してください。"
		data_file=gets.chomp
		#データを配列にいれて返す
		puts data_file.to_s
		a=file_array(data_file.to_s)
		delete_file?(a) unless a.empty?
	end
	
	def file_array(data_file)
		file_array=[]
		
		puts "#{data_file}"
		puts "#{data_file}"+"/**/*"
		Dir.glob("#{data_file}/**/*").each do|file|
		unless File.directory?(file)
		file_array << file
		else
		@dir_list << file
		end


		end

		puts "sort後"
		file_array.sort!
		
		raise  "ファイルがありません" if file_array.empty?
		file_array.each do |i|
			#md5=Digest::MD5.hexdigest(File.open(i,'rb').read) if File.file?(i)
			md5=Digest::MD5.file(i).hexdigest() #if File.file?(i)			
			md5_s=md5.to_s
			@file_data[i]=md5_s
			@file_data_hikumono[md5_s]=i
		end
		#valu(md5_s)が一致するものがある場合、それだけを残す。
		hiku=@file_data_hikumono.invert
		file=@file_data.to_a-hiku.to_a
		p file

		return file
	end

	def delete_file?(a)
		#sorted_hash=a.sort{|(k1,v1),(k2,v2)| v2<=>v1}
		#hashのuniqでハッシュ値が一致するものを抽出する。
		#a.uniq!
		
		
#		pp ary
		

#		@zyohuku_utagai=sorted_hash.select{|key,val| sorted_hash[key+1]==val}
	
		#@zyohuku_utagai=ary.select.with_index do |e,i| 
		
#		p @zyohuku_utagai
		#重複しているデータリストをつくる
#		a.each do |i|
#			@zyohuku_kakutei_data << i if @zyouhou_utagai.include?(i)
#		end
		@zyohuku_utagai=a
		puts "重複しているファイルは以下の通りです。"
#		p @zyohuku_utagai
		@zyohuku_utagai.each{|i| puts i[0]}
		puts "合計で以下の容量が解放されます"
		@zyohuku_utagai.each{|i|
		file_data=File.stat(i[0])
		@sum_size+=file_data.size	
		}
		puts "#{@sum_size}byte"
		delete_file()	
	end

	def delete_file
		puts "重複しているファイルを削除しますか？(y/n)"
		i=gets.chomp
		if i=="y"	
			@zyohuku_utagai.each{|elm1,elm2| File.delete(elm1)}
			puts "削除しました"
			#空になったかもしれないディレクトリを削除する。(追加予定）
			#delete_dir(@dir_list)
		elsif i=="n"
			puts "削除しませんでした"
		else 
			puts "なにもしませんでした"
		end
	end

	def delete_dir(dir_list)
		dir_list.each do |dir|
			Dir.rmdir(dir) if dir_size?(dir)==0
		end	
		
	end
	
	def dir_size?(path)
		sum=0
		path=File.expand_path(path)
	Dir.glob("#{path}/**/*") do |fn|
		next if File.directory?(fn)
		sum+=File.stat(fn).size
	end

	sum
	end
end
clean=CleanTool.new

clean.main

