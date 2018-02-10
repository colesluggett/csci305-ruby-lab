
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# Cole Sluggett
# csluggett@yahoo.com
#
###############################################################

$bigrams = Hash.new # The Bigram data structure
$bigramsArray = Hash.new
$name = "Cole Sluggett"
$count = 0

# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "

	begin
		counter = Hash.new
		file = File.open(file_name)
		until file.eof?
			file.each_line do |line|
				# do something for each line
				title = cleanup_title(line)
				unless(title == "")
					bigram = title.split().each_cons(2).to_a
					bigram = bigram.map{ |n| n.join(' ')}
					bigram = bigram.each_with_object(Hash.new(0)){|word, obj| obj[word] += 1}
					if bigram.any?
						counter.merge!(bigram) { |k, old, new| old + new}
					end
				end
			end
		end
		file.close

		$bigramsArray = counter.sort_by { |k, v| -v }
		create_hash()
		#$bigrams = $bigrams.to_h

		#$bigramsHash = Hash.new
		#$bigramsHash = $bigrams.to_h
  	#$bigrams.each { |k, v| puts "#{v} => #{k}"}


		puts "Finished. Bigram model built.\n"
	rescue
		STDERR.puts "Could not open file"
		exit 4
	end

end

# Executes the program
def main_loop()
	puts "CSCI 305 Ruby Lab submitted by #{$name}"

	if ARGV.length < 1
		puts "You must specify the file name as the argument."
		exit 4
	end

	# process the file
	process_file(ARGV[0])
	#mostCommonWord = mcw("love")
	#puts mostCommonWord
	#puts $bigrams['love']


	word = nil
	while word != "q"
		puts "Enter a word [Enter 'q' to quit]:"
		word = $stdin.gets.chomp
		unless word == "q"
			puts create_title(word)
		end
	end

	word = $stdin.gets.chomp
	puts allWords(word)
	# Get user input
end

def create_hash()
	$bigramsArray.each do |search|
		first = "#{search[0].split.first}"
		last  = "#{search[0].split.last}"
		value = "#{search[1]}".to_i
		if $bigrams["#{first}"]
			$bigrams["#{first}"].merge!({last => value})
		else
			$bigrams.merge!(first => {last => value})
		end
	end
end

def cleanup_title(title)
	title.gsub!(/.*(?<=>)/, '')
	title.gsub!(/\(.*|{.*|\[.*|\\.*|\/.*|_.*|-.*|`.*|\+.*|=.*|\*.*|feat..*|:.*|".*/, '')
	title.gsub!(/[?!¿¡\.;&@%#\|]/, '')
  if !(title =~ /^[\w\s\d']+$/)
  	title.clear
	end
	title.downcase!
	title.gsub!(/\b(a|an|and|by|for|from|in|of|on|or|out|the|to|with)\b/,'')
	title
end

def mcw(word)
	$bigramsArray.each do |bigram|
		firstWord = "#{bigram[0].split.first}"
		if firstWord == word
			return bigram[0].split.last
		end
	end
	return "No matches found"
end

def allWords(word)
	count = 0
	$bigramsArray.each do |bigram|
		find = "#{bigram[0].split.first}"
		if word == find
			puts "#{bigram}"
			count += 1
		end
	end
	puts count
end

def create_title(word)
	count = true
	songTitle = word
	check = true
	songArray = Array.new
	previousWord = songTitle
	while count
		currentWord = previousWord
		songArray.push(currentWord)
		if (mcw(currentWord) != "No matches found")
			nextWord = mcw(currentWord)
			songArray.each do |songword|
				if(songword == nextWord)
					check = false
					count = false
				end
			end
			previousWord = nextWord
			unless check == false
				songTitle = "#{songTitle} #{nextWord}"
			end
			#count += 1
		else
			count = false
		end
	end
	songTitle
end


if __FILE__==$0
	main_loop()
end
