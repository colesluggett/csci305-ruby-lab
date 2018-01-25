
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
$name = "Cole Sluggett"
$count = 0

# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "

	begin
		counter = {}
		IO.foreach(file_name) do |line|
			# do something for each line
			title = cleanup_title(line)
			unless(title == "")
				bigram = title.split().each_cons(2).to_a
				bigram = bigram.map{ |n| n.join(' ')}
				bigram = bigram.each_with_object(Hash.new(0)){|word, obj| obj[word.downcase] += 1}
				if bigram.any?
					counter.merge!(bigram) { |k, old, new| old + new}
				end
			end
		end

		$bigrams = counter.sort_by { |k, v| -v }

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
	mostCommonWord = allWords("love")
	puts mostCommonWord
	# Get user input
end

def cleanup_title(title)
	title.sub!(/%\w*<SEP>\w*<SEP>.*<SEP>/, '')
	title.sub!(/\(.*|{.*|\[.*|\\.*|\/.*|_.*|-.*|`.*|\+.*|=.*|\*.*|feat..*|:.*|".*/, '')
	title.sub!(/[?!\.;&@%#\|]/, '')
  #title.sub!(/[¿¡]/, '') #These two character will cause error.

  if !(title =~ /^[\w\s\d']+$/)
    title.clear
  end
  title.downcase
  unless(title == "")
	#puts title
  end
  title
end

def mcw(word)
	$bigrams.each do |bigram|
		firstWord = "#{bigram[0].split.first}"
		if firstWord == word
			return bigram[0].split.last
		end
	end
	return "No matches found"
end

def allWords(word)
	count = 0
	$bigrams.each do |search|
		find = "#{search[0].split.first}"
		if word == find
			puts "#{search}"
			count = count + 1
		end
	end
	puts "#{count}"
end


if __FILE__==$0
	main_loop()
end
