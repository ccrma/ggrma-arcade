public class Data {
    " {begin} (Player) (I heard a tip that they're in this bar. My partner...)
    (Player) (Surely, they're one of these robots, right? I've checked so many other buildings in the vicinity already...)
    (Player) (Since they uploaded their memory before they passed away, their robot counterpart must act like them, too.)
    (Player) (They say the best way to identify a robot clone is by learning more about them... Particularly, their thoughts on humans.)
    (Player) (I have to be careful, though. Robots are known to be predisposed to violence. This could get ugly for me if my cover is blown.)
    (Player) (So... who will be my first victim?)
    // End Exposition
    (NPC:Doju) Oh, a new face. Are you new to the area? It's rare to see models like you around here.
    (NPC:Doju) Come right in. The patrons here are a motley crew, but they don't bite.
    (NPC:Doshiba:Suspicious) ...What are you looking at? Don't you know it's not polite to stare? Get the hell out of my face.
    (NPC:Doju) ...Regardless, this is a somewhat popular location: There's an urban legend that you'll find what you're looking for here...
    (NPC:Dolbi:Sad) But barkeep, you've *got* to control them! We have too many people coming in looking for love!
    (NPC:Doju) ...Anyways, can I get you started with anything?
    // Choice
    ? I'll have a ....
    - beer [beer]
    - shot [shot]
    - cocktail [cocktail]
    // Choice: Beer
    {beer} (NPC:Dolbi:Happy) Barkeep, can I get another glass as well? I'll have your fanciest pint.
    (NPC:Doju) Sure, two beers coming up. [drink]
    // Choice: Shot
    {shot} (NPC:Daisun:Happy) wow, a real partier, huh? give 'em your strongest!! >:3
    (NPC:Doju:Suspicious) Ignore the heckling. One shot of motor oil for you coming up. [drink]
    // Choice: Cocktail
    {cocktail} (NPC:Doshiba) You should ask that they don't water down your drink... 
    (NPC:Doju:Angry) I definitely don't water down our drinks. You just seem to be building up a tolerance... [drink]
    // Resume: Drink
    {drink} (NPC:Doju) So, out of the three here, are any of them the one you're looking for?
    (Player) I'm not really looking for anyone in that way. Just here for a friendly drink.
    (NPC:Doju:Suspicious) Is that so? A little odd for a new face to do so in a war memorial town.
    // Choice
    ? Huh? What do you mean by ... town?
    - war [war]
    - memorial [memorial]
    // Choice: War
    {war} (NPC:Doju:Suspicious) Is your memory out-of-date? You might be due for a software update, my friend. 
    (NPC:Doju) It's a small town, but it was where one of the inciting incidents for the Great Robot-Human War happened. You know, the reason why we're all free and not serving humans right now. [town]
    // Choice: Memorial
    {memorial} (NPC:Doju:Suspicious) Is your memory out-of-date? You might be due for a software update, my friend.
    (NPC:Doju) It was really tragic. A lot of robots were cruelly dismantled here in retaliation for fighting back against our abuse. It really sparked a movement. [town]
    // Resume: Town
    {town} (NPC) Haven't you noticed that a lot of establishments here are named to honor it? That's why this bar is named the Robots Overthrew Humans and Gained Independence Bar.
    (NPC:Daisun:Suspicious) this is, like, a historic site! signs everywhere commemorating everything!
    (NPC:Doju:Suspicious) Hmm... You're not... a human, right?
    // Choice
    ? Of course, I ... a human.
    - am [am]
    - am not [am not]
    // Choice: Am
    {am} (NPC:Doju:Angry) You little... No wonder you have no idea how much damage you've done! WE HAVE AN INTRUDER! [die]
    // Choice: Am Not
    {am not} (NPC:Doju:Suspicious) ...Maybe you just need to have a few things reconfigured...
    (NPC:Doju) I'll hold off on your drink, so why don't you try talking to someone and regaining your bearings?
    (Player) (I almost blew my cover there... I need to be more careful and blend in if I want to find my partner.)
    // Choice
    ? (Let's try doing some recon. I feel like my partner acted the most like ....)
    - Doshiba [Doshiba]
    - Dolbi [Dolbi]
    - Daisun [Daisun]

    // Choice: Doshiba
    {Doshiba} (NPC:Doshiba:Suspicious) You keep staring at me. Knock it off, it's creepy.
    // Doshiba - Choice 1
    ? I'm only staring because you ... me.
    - cared about [cared about]
    - interest [interest]
    - despise [despise]
    // Doshiba - Choice: Cared About
    {cared about} (NPC:Doshiba) The cocktail thing I said earlier? Don't get me wrong, that was a jab at the barkeep! [doshiba1]
    // Doshiba - Choice: Interest
    {interest} (NPC:Doshiba:Love) Wh-what are you talking about? You think you can shake a hardened veteran like me? [doshiba1]
    // Doshiba - Choice: Despise
    {despise} (NPC:Doshiba) And where did you get that idea from? You're the one who keeps staring at everyone with your huge unnerving eyes. [doshiba1]
    // Doshiba - Resume
    {doshiba1} (NPC:Doshiba:Suspicious) What's even wrong with you anyways? Did someone try to brainwash you by rewriting your memory about the war?
    (NPC:Doshiba:Happy) Honestly, I got nothing against humans. And didn't some of them try to become robots, too?
    (NPC:Doshiba) Robots with human-like memories injected in them. Those ones always gave me... the creeps.
    (NPC:Doshiba) If it were up to me, I'd fix them up in my own way. Something about that is just not right.
    (Narrator) They take a long sip of their cocktail, brown shimmering liquid slowly slipping down whatever robotic equivalent of an esophagus.
    (Narrator) Their empathy reminded you of a certain someone.
    (NPC:Doshiba:Sad) I was in the war, but... If I had to be honest with you... I didn't actually participate.
    (NPC:Doshiba:Sad) I was shipped off to manage one of the facilities. But I never saw anyone there. Maybe mine wasn't the primary battlefield, but it was just me and empty space.
    (NPC:Doshiba:Sad) The occasional warning signal, the occasional torn-up robot. But nothing major. Nothing gruesome like what happened here.
    (Player) What do you mean? What did you do at the facility then?
    (NPC:Doshiba:Angry) That's confidential! Why do you even care? Aren't you one of those war deniers?
    (NPC:Doshiba:Angry) The barkeep might be kind enough to give you the benefit of the doubt, but I've seen plenty of your kind before.
    (NPC:Doshiba:Suspicious) What kind of robot even are you?
    (NPC:Doshiba:Suspicious) You certainly don't look like a combat model, and your ragtag build is unlike anything I've seen. And I've been trained to identify almost every common model.
    (NPC:Doshiba:Suspicious) Really, what *did* you even do during the war?
    // Choice 2
    ? I did ....
    - nothing [nothing]
    - paperwork [paperwork]
    - patching [patching]
    {nothing} (Player) ...And neither did you. because there was no war.
    (NPC:Doshiba:Angry) Are you being serious right now?! Didn't you *just* hear what I said? [bad:Doshiba]
    {paperwork} (NPC:Doshiba:Suspicious) We're ROBOTS. We don't even use paper for anything! Haven't you heard of contactless?! [bad:Doshiba]
    {patching} (NPC:Doshiba:Happy) Oh, you helped repair robots? We both did honest work, then. [doshiba2]
    {doshiba2} (NPC:Doshiba) So what about you? What kind of combat did you see?
    (Player) I looked after robots with transplanted memories.
    (Narrator) Doshiba's facial display turns a bright pink, an uncannily human hue.
    (NPC:Doshiba:Love) Wh-why those robots? Did you like something about them?
    // Choice 3
    ? Yes. I liked that they were ....
    - different [different]
    - the same [the same]
    {different} (Player) They all have that uncanny valley vibe to them.
    (NPC:Doshiba:Suspicious) Wait, you found them funny? I thought everyone found them creepy.
    (NPC:Doshiba:Happy) Didn't realize you were chill like that. Maybe we can be friends in this wasteland, after all. [neutral:Doshiba]
    {the same} (Player) I still remember when I was a human. I think about it all the time, in fact.
    (Player) (Who am I kidding. I *am* human.)
    (NPC:Doshiba) You, too? More than myself, I think most about the people in those memories, who I cherished and will never get to see again.
    (NPC:Doshiba:Sad) If only I could be with them again, human or not...
    (Player) (Could they be the one I'm searching for? Maybe there is something special about the bar. Might as well shoot my shot... What could go wrong?) [good:Doshiba]
    
    {bad:Doshiba} (Narrator) The atmosphere in the bar suddenly grows heavy.
    (Narrator) Doshiba's face, once a gentle pale green, turns a dark blood red as they open their chassis to reveal what looks like a combat-grade titanium bonesaw.
    (Narrator) You don't think you're going to make it through the night as they set it to your soft squishy cardboard casing.
    (Narrator) You soon learn of the bonesaw's reliability regardless of the medium it cuts through. [end]
    {neutral:Doshiba} (Narrator) In the not-so-distant future, you and Doshiba set up a repair shop and work lovingly together, hand-in-metallic-hand, until the end of your brief, natural lifespan.
    (Narrator) Doshiba learns of and accepts your human identity, and it complements Doshiba's fragmented human memories. [end]
    {good:Doshiba} (Narrator) You enjoy their companionship and witty banter for some time, but something feels missing despite the back-and-forth and despite the teasing.
    (Narrator) The restless longing for your past partner inevitably pulls you away, and you grow distant. The search continues... [end]
    
    // Choice: Dolbi
    {Dolbi} (Player) Hey there, fellow bot. How's your beer?
    (NPC:Dolbi:Suspicious) Well, *that's* an unusual way to greet someone. What firmware version were you released on?
    (Player) Uhhh...
    (NPC:Dolbi:Suspicious) Slow-witted too, I see. Although that's probably more than obvious from your lack of knowledge about the area.
    (NPC:Dolbi:Suspicious) Must be pre-12512525.0152311.5253553 patch.
    (NPC:Dolbi:Sad) Hm, that means you don't even have the upgraded neural DSP processors either. What's even the window size of your FFT unit? 
    // Choice 1
    ? ...?
    - Huh [huh]
    - What [what]
    - 512 samples [bad:Dolbi]
    {huh} (NPC:Dolbi) Okay, trick question. I just had to check. [dolbi1]
    {what} (NPC:Dolbi) Okay, trick question. I just had to check. [dolbi1]
    {dolbi1} (NPC:Dolbi) But wait, the way you grunted just now... Your speech synthesis model is absolutely immaculate.
    (NPC:Dolbi:Happy) Code me impressed-they really don't make them like they used to.
    (Player) (I guess natural human speech is still the gold standard despite them winning the War... Funny how it works like that.)
    (NPC:Dolbi:Happy) I can't believe I'm granting such an opportunity to the likes of your model, but I want your voice to narrate my current documentary.
    (NPC:Dolbi:Sad) Speech synthesis models these days just sound flawless, hence lifeless. Nothing comes close to anything *actually* suitable for my art.
    (Player) What movie are you making?
    (NPC:Dolbi) Not movie, *documentary.* Robot youth have already forgotten the War, but we all still live in its shadow. I document its history.
    (NPC:Dolbi:Sad) It's a thankless service for such an important need.
    // Choice 2
    ? Why is that ...?
    - a need [a need]
    - thankless [thankless]
    {a need} (NPC:Dolbi) There's a famous human saying: Those that do not learn from history are doomed to repeat it... [dolbi2]
    {thankless} (NPC:Dolbi:Sad) You know how we robots are. Always looking to the future and technology in search of answers... [dolbi2]
    {dolbi2} (NPC:Dolbi:Happy) ...But by understanding our history, we understand ourselves.
    (Narrator) You feel taken aback by the genuine display of purpose. Their passion reminds you of a certain someone.
    (NPC:Dolbi) I collect first-robot accounts of the war, though far and few between, and stitch them together.
    (NPC:Dolbi:Love) Presently, I'm working on terribly delicate scene: did you know that, up to and during the war, in rare cases there were purportedly robots and humans who fell in *love* with each other?
    // Choice 3
    ? Yeah, I ....
    - remember [remember]
    - know [know]
    {remember} (NPC:Dolbi:Suspicious) What do you mean you *remember?* You can't expect me to believe that you were actually there?
    (Player) I was, but not in the way that you would expect.
    (NPC:Dolbi) Were you... in love? Don't tell my colleagues, but I've always wondered what that felt like you know, beyond mere intellectual curiosity.
    (Player) (Well... here goes nothing. Now's the best chance I have.)
    (Player) I can show you, if you give me the chance. I'll ChucK you => now.
    (Narrator) Hesitation flashes across Dolby's bulbous eyes, quickly transforming a look of deep, wistful yearning.
    (Narrator) His brass features, once harsh and geometric, now look soft and smooth in the dim bar lighting. [good:Dolbi]
    // neutral Dolbi ending
    {know} (NPC:Dolbi:Happy) How educated of you. Because of the censors, few are aware that irrational, romantic, robot-human “love” was the basis for the War. That's my thesis, anyhow.
    (Player) Wasn't it the massacre?
    (NPC:Dolbi:Sad) That's nothing more than government propaganda, framing it as a random act of violence to justify further, organized violence.
    (NPC:Dolbi:Sad) But without a true, reliable source of information, we will never know for sure. [neutral:Dolbi]

    {bad:Dolbi} (NPC:Dolbi:Angry) Okay, now I know you're bluffing. Off by a few orders of magnitude from even the oldest models. And sound is a particle these days, anyways.
    (Narrator) His already eery countenance now turns into a wicked grin. A well-worn crimson record emerges from his abdomen and is placed delicately on his central turntable.
    (Narrator) The needle drops, the record rotates.
    (Narrator) A horrible synthetic screeching noise begins to emerge from Dolbi, piercing through your eardrums and cerebellum into what feels like the innermost depths of your soul.
    (Narrator) Your eardrums have long-since ruptured as you begin to lose consciousness, the last fleeting thought in your mind being: 'Is this... computer music?' [end]
    {neutral:Dolbi} (Narrator) You enjoy listening to their passionate monologues about media and robot history for some time, but something nags at you. You wonder if Dolbi is who you're looking for.
    (Narrator) The restless longing for your past partner inevitably pulls you away, and you respectfully take your leave. The search continues... [end]
    {good:Dolbi}(Narrator) Dolby eventually realizes you are human, and loves you all the more for it.
    (Narrator) You become his muse, providing primary-source material and an invaluable human perspective for his film career.
    (Narrator) As a duo, your work makes waves across the robot literati, blazing the the trail for Robot new-wave cinema. [end]

    // Choice: Daisun
    {Daisun} (NPC:Daisun:Happy) h-heyyyy good looking! i mean good morning, oops i mean good afternoon i mean. oh no...
    (Player) ...
    (NPC:Daisun:Love) can i start over please.
    (NPC:Daisun:Happy) hiya i'm daisun! i like long walks by the Breach and i, like, come to this place allll the time haha is that embarrassing XD...
    (Player) (wait, how are they saying XD out loud?)
    (NPC:Daisun:Love) do you like my vacuum? ...is that weird to say on the first date...? wait, is this how dating works? oh gosh i'm so bad at this aren't i. 
    (Player) Honestly, I don't think anybody really knows how dating *works.* If they say they do, they're lying.
    (NPC:Daisun:Happy) i-... i never thought about it like that... heehee.. you're, like, actually nice. 
    // choice 1
    ? Thanks, I'm just being ....
    - human [human]
    - normal [normal]
    - myself [myself]
    // choice: human
    {human} (NPC:Daisun:Happy) HUEHUEHUEHUE
    (Narrator) Dyson emits a huge cloud of dust as they double over from laughter.
    (NPC:Daisun:Happy) you're funny too! [daisun1]
    {normal} (NPC:Daisun:Sad) oh...normal... I'm normal too!
    (NPC:Daisun:Angry) In fact, I'm as NORMAL as they come! SeE, LoOK HoW uSefUL I CAN BEEEEEE!!! [bad:Daisun]
    {myself} (NPC) oh wow... that's brave of you. [daisun1]
    {daisun1} (NPC:Daisun:Love) i'm actually...sorta having a good time with you... wow, this never happens. i really needed this after last time...
    (NPC:Daisun:Suspicious) oh, did you not hear? a gang of robo-raiders came through town not long ago, swung by this bar to confront someboty about unfinished business. 
    (NPC:Daisun:Sad) i was, like, SOOOO scared. but they were being sooo Mean! to everyone! i couldn't just stand and watch... so, i turned on my vacuum.
    (NPC:Daisun) i... i know i'm strong but... every time i help, i just make a bigger mess, and others get hurt.
    (NPC:Daisun:Sad) that seems to happen a lot when i try to be myself.
    (Narrator) Daisun lets out a dusty sigh, but you feel touched by their courage. Their selflessness reminds you of a certain someone.
    (NPC:Daisun) but it wasn't always like this. you know the war? th-the big one?... 
    (NPC:Daisun:Happy) yea, after the battles, they would send me out to clean up the carnage. not to brag, but i was really fast and thorough hehe... and i actually felt useful? y'know? 
    (NPC:Daisun) i only ever saw random robot parts, but i always hoped i'd find a human, just to see for myself what they were really like.
    (NPC:Daisun:Suspicious) like, are they actually as dirty as they say? did each of them really have their own cleaning robots, all those years ago?
    (NPC:Daisun:Love) imagine always being needed to help clean...
    (Narrator) Daisun looks wistfully into the distance, once-playful eyes glazing over. Wherever their robot mind was headed to, you didn't like it.
    // choice 2
    ? Well, if I were human, I would be very ....
    - dirty [dirty]
    - clean [clean]
    {dirty}
    (NPC:Daisun:Happy) ASDFGHJKL 
    (NPC:Daisun:Love) soo, what you're saying is that maybe i could help clean... you... sometime? ;-)
    (Narrator) You see the earnestness and intensity in their eyes. In a split second, without even having to try, you make up your mind.
    (Player) (I can fix them.) [good:Daisun]
    {clean}
    (NPC:Daisun:Happy) ah i see, we have a fellow clean freak >:)
    (NPC:Daisun:Happy) soo, what youre saying is that maybe i could help you start a cleaning empire... sometime? as... as business partners! [neutral:Daisun]

    {bad:Daisun} (Narrator) A switch flips, and a deafening rumble fills the bar. Daisun's vacuum roars to life.
    (Narrator) The glasses, chairs, tables all begin lurching towards Daisun from the difference in pressure. That thing was definitely NOT meant for indoor use.
    (Narrator) Before you can realize, your shabby cardboard disguise is stripped away and sucked into oblivion, revealing a fleshy, flabby mortal coil.
    (Narrator) Now every robot head in the bar is turned and gawking directly at you. Daisun cranks up the power with a devious smile. [end]
    {neutral:Daisun} (Narrator) You see the business savviness and founder mentality in their eyes. In a split second, without even having to try, you make up your mind.
    (Narrator) It turns out, Daisun didn't need to be fixed. They just needed OKRs and KPIs to set them straight and measure their value.
    (Narrator) It turns out, business and monetary validation was just as good as emotional validation.
    (Narrator) You both become cleaning moguls, and your business dominates the market.
    (Narrator) Daisun's status is never again questioned, and neither is yours. [end]
    {good:Daisun} (Narrator) It turns out, Daisun didn't need to be fixed. They were just kind of awkward.
    (Narrator) And in need of someone who loves them for who they are.
    (Narrator) Your unclean living habits complement them perfectly.
    (Narrator) You live out the rest of your natural lifespan together, enjoying the simplicity of life in the wastelands.
    (Narrator) Long after you've passed, your living quarters remain pristine. [end]
    " => static string script;


    " (Player) Pretty neat game, wonder who made it...
    (NPC:Dolbi) My records show a certain 'azaday' was responsible for the music. 
    (NPC:Dolbi:Happy) Somewhat plebeian by my standards, but I suppose it suffices. 
    (NPC:Daisun) oh wow it turns out all art assets were handmade by Audrey Lee, Gray Wong, and gunoo.
    (NPC:Daisun:Love) so talented!! uwu. i hope i can draw like that some day... 
    (NPC:Doshiba) Scanning logs... looks like azaday and Ben Hoang wrote most of the code here. 
    (NPC:Doshiba:Suspicious) Personally, I've always thought code should be written by robots. But well done, I guess.
    (NPC:Doju) And everyone contributed to SFX and voiceovers: Audrey Lee, azaday, Ben Hoang, Gray Wong, and gunoo.
    (NPC) Now that's some teamwork! If yall ever swing by, drinks are on the house!
    (Narrator) Despite this being a game about robots ... NO AI WAS USED. All music/code/art was lovingly hand-crafted.
    (Narrator) Thank you to Ge Wang and the rest of the CCRMA community for all your support!
    (Narrator) Programmed in ChuGL/ChucK for WASTELAND Jam 02 by Good Game Research in Music & Acoustics (GGRMA), a research group at Stanford University's CCRMA.
    " => static string credits;
}