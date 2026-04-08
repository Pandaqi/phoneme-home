# Phoneme Home (pun on Phoning Home)

A PHONEME/LANGUAGE Puzzle Game. 

You can click on stuff to hear their sound, and must then put stuff in the right order to spell a word!

* I can use the **Shufflespeak/Noisy Tongues** dataset I already made!
* I simply grab the phonemes needed for a word, then shuffle them around.
* While playing ...
  * You can click stuff as often as you want to _hear_ the sound. This also selects it.
  * Then you can click any part/chunk of the word to slot it in there.
* Once done, it plays back the whole thing. If it shounds like the right existing word, the image for that appears and you've won!
* If not, they all wiggle and fall out. Try again.



# To-Do

## Crucial

@IDEA: Dino(saur), Dragon, other animals (literally the word ANIMAL)?


@IDEA: Add setting to _show_ the solution sprite + text. You just need to _spell it_ yourself!

* @BUG: If the Hint button requires pushing something out of a slot and immediately putting it back somewhere else, it breaks!
* POSSIBLE BETTER PHONEMES:
  * The schwa/short `u` could be a bit shorter/less pronounced.
  * The `d` could sound more like a dee and less like a tee.
* Create number sprites `0` to `10` in style of the few I already did, add to shared assets?
* Missing Solution Sprites => Only on lowest difficulties; 
  * Add a `sprite` property to those entries
  * Add a `sound` property with some audio for the full word ---> I can start by using the words I already have in shared assets!
    * Require BOTH sprite and sound on lowest difficulty? Or just ensure they all exist?

Create unique marketing image (from AI result) for this game?

## Other

@NOTE: Generate Mipmaps for all textures imported. It's the only way to make those thin outlines around them look antialiased. (Also, stick to powers of 2 scaling for all these sprites, everywhere!)

@IDEA: Also some hover on the slots? I kind of like NOT reacting there to really sell the idea of "this is a slot, not a phoneme, this is a final position"




# Notes / Research


Vowels typically last significantly longer than consonants in English, with short vowels lasting about 100–150 milliseconds and long vowels lasting around 200–300 milliseconds
. While the specific ratio varies, vowels often last roughly 1.5 times longer than consonants. 
Factors Influencing Duration:

    Vowel Type: Long vowels (e.g., in "bead") can last nearly twice as long as "short" vowels (e.g., in "bid").
    Following Consonant: Vowels are substantially longer when followed by a voiced consonant (e.g., d, g, z, v) compared to a voiceless/unvoiced consonant (e.g., t, k, s, f).
        "Bead" has a longer vowel than "beat".
        "Bag" has a longer vowel than "back".
    Syllable Position: Vowels at the end of a syllable (open syllables, e.g., "be") are usually the longest. 

Examples of Duration:

    Bead: ~350 milliseconds
    Beat: ~190 milliseconds
    Short Vowels: 100–150 ms
    Long Vowels: 200–300 ms 

In summary, a vowel's duration is highly dependent on its surroundings, particularly the voiced or unvoiced nature of the following consonant, a phenomenon often described in phonetics as pre-fortis clipping. 



Vowel length is a phonemic feature that distinguishes vowels based on how long they are pronounced. In phonetics, vowel length is measured in milliseconds (ms), while in phonology, it is described as a contrastive feature that can change one word into another.
For example, compare /ɪ/ (short) and /iː/ (long):
bit /bɪt/
beat /biːt/
Here, the difference between /ɪ/ and /iː/ is not only about sound quality but also about duration—the vowel /iː/ is held longer.
✅ Vowel Length in English
In English, vowel length often goes hand in hand with vowel quality, which refers to the position of the tongue and lips. Thus, long vowels are not only longer but also different in quality.
The short vowels in English include /ɪ, e, æ, ɒ, ʌ, ʊ, ə/ as heard in sit, pen, cat, pot, cup, put, and about. These vowels are brief, lasting about 100–150 milliseconds.
The long vowels include /iː, ɑː, ɔː, uː, ɜː/ as in see, car, saw, too, and bird. They are pronounced for a longer duration, around 200–300 milliseconds.
👇 Phonetic vs. Phonological Vowel Length
Phonetic vowel length refers to the actual time a vowel is held in speech, which can vary depending on stress, intonation, or speech rate.
Phonological vowel length refers to the meaningful contrast between vowels that changes word meaning.
For instance:
ship /ʃɪp/ vs. sheep /ʃiːp/
The length difference between /ɪ/ and /iː/ creates two distinct words.
👉 Factors Affecting Vowel Length
Several factors influence how long a vowel is pronounced:
1. Phonemic contrast – whether the vowel is inherently long or short, as in beat vs. bit.
2. Word stress – vowels in stressed syllables are usually longer, as in record (noun) /ˈrekɔːd/ vs. record (verb) /rɪˈkɔːd/.
3. Following sound – vowels before voiced consonants are longer than those before voiceless consonants, for example bead /biːd/ vs. beat /biːt/.
4. Speech rate – slower speech increases vowel duration, while faster speech shortens it.
5. Sentence position – vowels at the end of a phrase tend to be lengthened for emphasis.
✅ Symbol for Vowel Length in Phonetic Transcription
In the International Phonetic Alphabet (IPA), vowel length is shown using a colon-like symbol (ː) placed after the vowel.
Examples include:
/iː/ in see
/ɑː/ in car
/ɔː/ in law
/uː/ in food
/ɜː/ in bird
👇 Vowel Length and Meaning Distinction
Vowel length can change word meaning in English and many other languages.
For example:
bit /bɪt/ and beat /biːt/
full /fʊl/ and fool /fuːl/
cot /kɒt/ and caught /kɔːt/
Here, the difference in vowel length alone distinguishes one word from another, making vowel length phonemic in English.
✍ Summary: Vowel length is a time-based distinction that affects meaning, rhythm, and clarity in speech. In English, it works closely with vowel quality to produce meaningful contrasts—an essential feature for clear and accurate pronunciation.