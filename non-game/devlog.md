# Phoneme Home (Devlog)

Welcome to the devlog (or "developer's diary") for my unique language puzzle game [Phoneme Home](@TODO:Link). As I was making the first puzzle games for my educational online store, it was quite "easy" to find puzzles with shapes, colors, grouping, and other mathematics skills. When I say "puzzle", most people immediately think of _that_ kind of puzzles.

But a language puzzle? I struggled to find something that could work. How do we create a digital game with language problems to solve ... for kids who can't read yet? I saw it as a nice challenge to find something. I knew there _had_ to be a way. 

Eventually, the pretty simple idea of _Phoneme Home_ came to me.

## What's the idea?

Each puzzle is a simple, common **word**. One that young kids will likely know, even if only vaguely or by sound.

That word is, however, split into **phonemes**---into its _individual sounds_. These sounds are scattered across the screen. 

* The sounds are represented by images of common things that _start_ with that phoneme. (Example: a "B" sound will show a "BEE".)
* You can hear the sound by tapping / clicking on that sprite. You can do this as often as you need/want, of course.

_That_ is the puzzle! You must put these phonemes in the right order so that, when it plays them from left to right, you _hear_ the proper word.

The simplest interface for this, that a young child will likely understand, seemed to be something like this:

* As stated, you can tap on sprites to hear their sound, and you can do this easily and as often as you want. I don't want to interfere with this or overcomplicate that.
* When you tap a sprite, though, it is "selected".
* In the center of the screen are a few boxes where you have to "slot in" the phonemes.
* When you tap such a _box_, the phoneme currently selected moves into it!

Whenever you fill all boxes ( = "finish the word"), it will play the sounds from left to right. If correct, you've now solved the puzzle. Otherwise it empties the boxes and you can try again.

Other options that I discarded were ...

* I considered simply adding sounds from left to right automatically. Click something, it adds it in the _first_ position, click something else, it adds it in the _second_ position, and so forth. This, however, meant that clicking a sprite to hear its sound ... would also put it in a slot somewhere. Which is annoying and needlessly confusing.
* I also considered using the _entire screen_ as the boxes. You can drag-drop (or swipe) phonemes into zones, and it just constantly plays them from left to right. This had its own problems though (what if multiple things in the same zone? won't it be incredibly annoying to hear it play the word every 5 seconds?).

## Getting A Dictionary

Fortunately, I already had a big dictionary of words broken into their phonemes (and syllables, and other properties) from my earlier Language work. I could load this `.json` file into my game engine (Godot) quite easily and let it pick a word at random.

Similarly, I already had _sounds_ for phonemes, and a lot of _sprites_ for simple common words. I dropped all that into the same project.

Then, in that `.json` data file, I linked every sound/sprite to the proper phoneme. (I thought, if we're loading that big data file anyway, let's put all our other data into it too, instead of doing that through the game engine or code.) And so, in the end, that file has over 12,000 lines of data on words, their phonemes, what sounds to play for each phoneme, and what sprites to display.

That is, of course, a bit much. We don't need all of that. I immediately wrote simple functions to ask for words of a specific _length_, or _difficulty_, or only using a _subset of phonemes_. This will allow me to make different difficulty levels later, starting off easy with just a small pool of sounds and simple words, then expanding as we go.

I had a working prototype in about an hour. 

* It picks a random word.
* It creates a clickable image for each phoneme. Clicking it plays the right phoneme sound.
* Now I can try/play the puzzle myself.

And ... it sucked!

## Better Phoneme Sounds

The sounds I was using were not ideal when _played one after another_. The recordings were meant to teach what each individual phoneme sounded like, which means they are overly emphasized and drawn out. This made some sounds take way too long, while others got muffled, and some sounded so wrong that I could not even hear what word it was supposed to be.

{{% remark %}}
This was absolutely what I needed for my previous use case, such as a few sounds in a quiz about phonemes or language. It's just not what I need for THIS game.
{{% /remark %}}

I had to painstakingly create a new set of phoneme sounds for this game.

* Each sound is much _shorter_. (No empty space at beginning or end, nothing drawn out.)
* The sounds are the _actual phoneme_ as you'd typically use it in a word. (So not "ellll" but just "l"---stop. Hmm, this is hard to explain without audio examples ...)
* In my big `.json` file, I also specify how "long" to wait before playing the next phoneme. Consonants are fast. Vowels (especially open ones) should take a little longer before continuing to the next sound.
  * This is _related_ to the actual length of the sound file, but not necessarily the _same_. It sometimes sounds more fluent if the next sound already starts playing while the previous one is still wrapping up, or if you wait a tiny bit after a hard stop.
  * But yes, this was a lot of playing random solutions and nudging values until it sounded okay. Not very fun.

For many unfortunate reasons, I am not able to record these sounds myself at the moment or in the near future. I begrudgingly used an AI voice to say some random sentences, then performed some heavy editing to acquire all these individual phonemes.

## Everything Else

The name of the game, _Phoneme Home_, was a pun on _Phoning Home_. That phrase has a clear space / galaxy theme, about sending signals (sound waves?) back to your home planet. And so it was decided that the whole game would have a starry space theme.

Now, the game is a very simple and somewhat abstract puzzle, so this "theme" does not have a lot of chance to shine through or do much. But it still helps a lot to make the game feel a bit more interesting.

* I created some faint backgrounds of starry skies and galaxies. The puzzle randomly picks one to display across the whole background.
* I created some standalone planets, stars, asteroids, etcetera. A large number of these are randomly placed in the background, slowly drifting or pulsing to add a bit of liveliness. (This also includes some random "textures" that make the background look less like the same solid color each time. If you're not looking for it, you probably won't notice these random blobs overlaying the background in several places.)
* The phonemes became _stars_. The slots to place them into became stars too (to match).
* I created a LIGHT mode too, in case people prefer a bright background and black text/elements instead.
* Whenever you click a phoneme to hear its sound, I emit a few "sound waves" from it. (Just white thin circles that expand outwards quickly, like a ripple in a pond.) Makes it look even more alive and like "phoning home".
* I added the default effects and changes whenever you select/hover something, such as making it pop up (slightly bigger), or making that star _green_ when the phoneme was in the right place.
* And I added a little spaceship flying from left to right across the screen as it plays your word. This felt like a fun, fitting thing to add, but it also reinforces what's actually happening to a child playing. (As the spaceship moves left->right, it triggers the sounds of the slots left->right, so that's what you hear.)

All these things together take a few hours to illustrate, place, figure out, tweak. But in the end you have a puzzle game that looks much more lively and fun to play, even though you're still just clicking phonemes in the right order to get very simple words.

I also realized that I just did not have the time/resources to create an image for _every_ possible word. Words like "bus" and "bed" obviously show the image of the word you created (when you solve the puzzle), confirming and reaffirming it. But words like "after" of "before"? You can't illustrate them easily, which is why my shared library of assets (for the online store) does not have anything for it. 

I decided to simply move all such words to higher difficulties, at which point you only get to see the _word_ (written out: "AFTER") you created at the end.

I'm somewhat skipping past this step, even though it was a large chunk of the game's development, because it's not that interesting and nothing new really happens here. The crucial, new part was in the puzzle idea and the breaking up/playing of individual phonemes.

As such, with this part done ... the puzzle game was done!




# To-Do

## Crucial

* Get started with _better_ phoneme recordings.
  * Only do a few test words now with common phonemes: BED, NIGHT, RISKY (add that one?)
* Missing Solution Sprites => Only on lowest difficulties; Add a `sprite` property to those entries with the filename for it

* Also accept OTHER words you'll be able to make from those phonemes. (They are likely in that same list.)
* Allow giving hints anyway, using a mock command for phoneme->slot in order.


## Other

@NOTE: Generate Mipmaps for all textures imported. It's the only way to make those thin outlines around them look antialiased. (Also, stick to powers of 2 scaling for all these sprites, everywhere!)

@IDEA: Also some hover on the slots? I kind of like NOT reacting there to really sell the idea of "this is a slot, not a phoneme, this is a final position"




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