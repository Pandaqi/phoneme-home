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

This was a massive improvement ... **but still not great**.

I tried using the default _text to speech_-support within my Game Engine, I tried recording and editing the sounds in a different way, I even looked up the average duration of specific phonemes in the English language ... only to conclude that _this wasn't going to work_. The duration and exact sound of a phoneme simply depends on the context. In some words, my "b" sound was perfect, whilst in other words it sounded very weird and made the word nearly unintelligible. 

I realized why converting text to audio requires sophisticated technology :p I decided it was a bit foolish (or ambitious?) to think I could turn recordings of individual phonemes into realistic, natural sounding words (no matter their order). It simply doesn't work that way. Some words sounded great, others were choppy and bad, because speech is highly variable and context-dependent.

While experimenting with the timings and recordings, I discovered that the words were _much_ easier to understand if I actually **slowed down playback**. That is, if I did not even _try_ to make it a single word, but kept each phoneme as its individual sound (with some pauses between them). Whenever I did that, it was easy to understand what the entire word was, and it sounded consistent and professional. 

I think the key word here is "consistent". By making the duration of each phoneme _identical_, the playback gets a nice predictable pattern that makes it sound better and makes it easier to understand. So yes, in the final version, all phonemes actually wait for the same amount of time before continuing to the next. This makes the "choppy" sound---one phoneme at a time, not one word as a whole---actually okay and usable.

Finally, I realized that I could just ... add a **separate recording of the correct word in its entirety** to the game. I can't do this for _all_ words---it's too much---but I can do it for the easiest difficulties. In other words, I have a file called `bed.mp3` which contains someone saying the word BED in one go, as it should sound. When you complete a puzzle, I play _that file_ to confirm the right word, instead of only playing the individual phonemes. It seems a bit of a trick at first, but it just made sense once I'd actually implemented it. 

We now get a pretty nice flow for the puzzle.

* Try to sort the phonemes. 
* The system can play _any attempt_ by just playing the individual phonemes in order. So even wrong attempts are turned into audio.
* If you get it _right_, 
  * The system first plays the word slowly, as usual. (B-E-D)
  * Then it plays the word quickly, correctly, using that second recording as a sort of "confirmation". (BED!)

It's a bit annoying that I had to waste so many hours to get here, and throw away all that work just to return to this simpler solution. But at least the idea is possible and playable now.

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

I'm somewhat skipping past this step, even though it was a large chunk of the game's development, because it's not that interesting and nothing new really happens here. The crucial and unique part was in the puzzle idea and the breaking up/playing of individual phonemes.

Some other interesting improvements I made near the end where,

* Sometimes you can create multiple words with the phonemes (e.g. NET and TEN). When checking if your solution is "correct", I needed to check if your final word occurs anywhere in my big list. (Otherwise it's very annoying if you make TEN and think you've solved it, but the system says you're wrong because it wanted NET!)
  * This does not happen a lot, because the two words not only need to use the same phonemes but also be of identical length. 
  * But it happens surprisingly often. Often enough that I wanted to support this, instead of discarding all those duplicates from the dataset.
* Similarly, some words contain multiple of the same phoneme. I needed to change my code to make sure it doesn't matter in what order you use the two "k"-phonemes in cactus, for example.
* Finally, I wanted to be able to give "hints" in case you're stuck (even though this isn't your typical puzzle game). So I connected the default Hint button (in my puzzle framework) to some code that immediately places the right phoneme in the first open slot.
  * Everything in a puzzle game is just a "command". So, placing a phoneme in a slot, is just a command that can DO that, but also knows how to UNDO that.
  * Whenever you click a slot, I spawn a new command to DO it. 
  * So, when you press the "Hint" button, I UNDO any mistakes you've made and then simply call the next command from the correct solution.

As such, with this part done ... the puzzle game was done!

## Conclusion

I think the core idea is very solid. Even short words already create a nice little puzzle (for older kids/adults too!). All complexity is in the _task being taught_ (recognize phonemes + how they stitch together into word); actually giving your answer/solution is as simple as a few clicks. The game looks and feels nice to play thanks to some time spent on animations and effects, without overdoing it.

I'm still a bit disappointed about not finding a way to just play the phonemes and get a natural sounding final word out of that. My workaround required a _lot_ of work, and I still had to leave many words without that extra recording because it was just too much. The same thing is true for _images_ confirming you have the correct word (e.g. after spelling "bed" the final screen shows an image of a BED). It was a _lot_ of tedious work to get all images, sounds, and other data, and link them up properly. 

But in the end this allowed the game to work very well and have over 500 words in its database. I tried to make the marketing material do justice to the amount of content inside the game, asking a higher price than I asked for previous puzzle games. I have a habit of severely underselling what I make, going so far as forgetting to even _mention_ how much you get with a certain product, so I'm trying to be conscious of this ;)

There is probably some even _better_ language puzzle game for pre-readers out there. This puzzle game is a good first step towards finding it.

Until the next devlog,

Pandaqi