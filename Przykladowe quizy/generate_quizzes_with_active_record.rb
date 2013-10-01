#	It would be awesome if user could supplement with parsing rules
#	
#	Multiple choice question not supported :-(
#
#
#

require 'enumerator'

class Array
	def distribute_uniformly(no_buckets)
		buckets = [[]] * no_buckets
		
		self.with_index_each do |element, index|
			buckets[index % no_buckets] << element
		end
		buckets
	end
end


require 'securerandom'

$question_types_ids = 
					{
						'otwarte'		=> 11,
						
						'jednokrotny 2' => 2,
						'jednokrotny 3' => 3,
						'jednokrotny 4' => 4,
						'jednokrotny 5' => 5,
						'jednokrotny 6' => 6
					}
$answers_per_question_type = 
					{
						'otwarte'		=> 1,
						
						'jednokrotny 2' => 2,
						'jednokrotny 3' => 3,
						'jednokrotny 4' => 4,
						'jednokrotny 5' => 5,
						'jednokrotny 6' => 6
					}

def header(name)
	"\n\n #\t\t\t\t#{name}\n"
end


def create_answer(tresc_odp, correctness_level, pytanie_var_name)
	answer_var_name = "odpowiedz_wzorcowa_#{SecureRandom.hex(30)}"

	answer_model_data = "{:tresc_odp => \"#{tresc_odp.gsub(/"/, '\"').gsub(/'/, '\'')}\"," +
						":pytanie => #{pytanie_var_name}, :poziom_poprawnosci => #{correctness_level}}"
							
	"#{answer_var_name} = OdpowiedzWzorcowa.create(#{answer_model_data})"								 
end

def create_question(tresc, id_typu, id_autora, answers, quiz_var_name, answer_prefix)

	pytanie_var_name = "pytanie_#{SecureRandom.hex(30)}"
	
	question_model_data = "{:tresc => \"#{tresc.gsub(/"/, '\"').gsub(/'/, '\'')}\", :quiz => #{quiz_var_name}," + 
							":id_typu => #{id_typu}, :id_kategorii => Kategoria.default[:id_kategorii]," +
							":id_autora => #{id_autora}}"
	
	"#{pytanie_var_name} = Pytanie.create(#{question_model_data})\n"	+							 
	"#{answer_prefix}#{create_answer(answers[0], 100, pytanie_var_name)}\n" + 
	answers[1..-1].map do |answer|
			"#{answer_prefix}#{create_answer(answer, 0, pytanie_var_name)}"
	end.join("\n")
end


def create_quiz(questions_with_answers_chunk, id_typu, nazwa, id_grupy = 1, id_wlasciciela = 1, question_prefix = "\t")
	quiz_var_name = "quiz_#{SecureRandom.hex(30)}"
	
	quiz_model_data =	"{:nazwa => \"#{nazwa.gsub(/"/, '\"').gsub(/'/, '\'')}\", :id_wlasciciela => #{id_wlasciciela}," +
						" :id_grupy => #{id_grupy}}"
	
	"#{quiz_var_name} = Quiz.create(#{quiz_model_data})\n" +
	questions_with_answers_chunk.map do |question, answers|
		"#{question_prefix}#{create_question(question, id_typu, id_wlasciciela, answers, quiz_var_name, question_prefix * 2)}"
	end.join("\n") + "\n"
end


# 
#	Expected format:
#	
#	question_1
#	answer_1
#	.
#	.
#	.
#	answer_n
#	question_2
#	.
#	.
#	.
#
#	RETURNS
#		Enumeration of [question, [answer, ...]]

def parse_questions_and_answers(lines, answers_per_question)
	lines.each_slice(answers_per_question + 1).map do |chunk|
		raise "Wrong number of answers." if chunk.length != (answers_per_question + 1)
		[chunk[0], chunk[1..-1]]	# [question, [answer, ...]]
	end
end

def generate_seed_partial_for_quiz(path_to_file, name, question_type, questions_per_quiz = nil, id_grupy = 1, id_wlasciciela = 1)
	
	raise "Unknown question type." if not $question_types_ids.include?(question_type)
	
	type_id = $question_types_ids[question_type]
	answers_per_question = $answers_per_question_type[question_type]
	
	lines = File.readlines(path_to_file).each { |line| line.strip! }
	
	quizzes_rb = File.new "#{name}_append_this_to_seed_rb.rb", "w"
	
	quizzes_rb.write(header(name))
	
	# Parse content_files
	# 
	questions_with_answers = parse_questions_and_answers(lines, answers_per_question)
		
	# Oh yeah
	questions_per_quiz = questions_with_answers.length / Math.log2(questions_with_answers.length).ceil if questions_per_quiz.nil?
	
	questions_with_answers.each_slice(questions_per_quiz).each_with_index do |chunk, index|
		quizzes_rb.write create_quiz(chunk, type_id, "#{name} #{index + 1}", id_grupy, id_wlasciciela)
	end
end


raise "ARGV should have at least 3 arguments" if ARGV.length < 3

path, name, question_type = ARGV[0], ARGV[1], ARGV[2]
id_grupy = ARGV.fetch(3, 1)
id_wlasciciela = ARGV.fetch(4, 1)
questions_per_quiz = ARGV.fetch(5, nil)

generate_seed_partial_for_quiz(path, name, question_type, questions_per_quiz, id_grupy, id_wlasciciela)

