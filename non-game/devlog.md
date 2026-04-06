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






# To-Do

* Input Slots
  * Display
  * Slot In
  * Play final result
  * Check if correct or not
* Missing Phoneme Sprites
* Missing Solution Sprites
  * Only do this for a much smaller subselection
  * Everything else just displays a standard sound sprite ---> these are only used at higher difficulties!