---
icon: material/newspaper
---

# News

!!! info "Info"
        This page is more of a journal to what I am working on and updating.
        Feel free to check here sometimes.

## Updates

---

### 007 - Progress

---
I am happy to be able to say that I am finally able to make some Progress on this thing again!

Now I am almost completely through with changing it to the new code Structure.

One can still use the same commands just like before. Now it should be better and more clean tho.

Have fun! :D

### 006 - Random

---
hello there!

I am just randomly making a new news thing here right now just because I want to try something and I couldn't find what else to commit. 

I want to be able to work on this project in school or anywhere actually XD so I am installing VS code server on my server with the repo in it.

yayy

### 005 - Big Changes

---
some big changes will be coming soon. I am learning how to add a .sh file into the /usr/bin/ directory myself and commands will change a lot!

[customization](customize.md) will also be possible soon then!

I hope this works nicely when I do it.

### 004 - Idea

---
So.. I just woke up after some horrible sleep.. and I think I have an Idea of how to add the customize feature.

What if I make the apt command more modular? that the commands *inside* the aptt command for example are seperate and just have to be put in the aptt command via some kind of list or something..
people could easily add their own update commands..

also I want to make some kind of overwrite system maybe. I think that might be nice.

of course I will have to see first how I will do this..

idea for the modular aptt command:

```bash
update-command1() {
    echo "-------------"
    echo "updating command1"
}

update-command() {
    echo "-------------"
    echo "updating command"
}

aptt() {

    # updates command 1
    update-command1
    
    # updates command 
    update-command
    
}

    ## or:

update-command() {
    echo "-------------"
    ec
    
aptt-list() {
    # some code that reads a global file of available update commands. commands that run in a specific oder with the aptt command.
    # maybe add a new source file with it.
    
}

aptt() {

    # function that runns all of the commands that aptt-list gets.
    # we'll see how I do that.
    aptt-list
    
    # fixed command, if I need it somehow. I think I won't
    fixed-command

}

```

### 003 - Tired

---
I am pretty tired as I am writing this. I finally filled the [Usage](usage.md) page. I still have to add the [Customize](customize.md) page. There aren't even any cutomization options yet XDD

Will have to add them I guess..

also I want to add more settings commands. I think that might be nice.

and more commands in general. we can make this big! ahahahahaahaa

*good night!*

### 002 - README

---
lol, I just made the README much smaller and simpler.

wanna see the old one?

[here it is!](README_old.md)

Truly a relic.

### 001 - Changelog added

---
So, I just added the changelog. This will be more me just taking about what I am working on right here. Kind of like news, so I named it "News". 

Things I got so far in these docs is [Welcome](index.md) and [Idea](idea.md).

The page currently looks like this:

![Site](media/site.png)

just so you, dear viewer of this relic, can see what I am working on. I will update this page whenever I have something to say about the project or the docs. And I really just want to express any random stuff about developing this here.

So I honestly use some AI, mainly Perplexity to write me some functions and other stuff. I am able though to write simple things myself, but the code is not really good and this is more simple.

So.. if you are reading this and want to contribute to anything here really, feel free to make PR's! Maybe even add your own update code to the `aptt` command or some of your own ideas, spell corrections or preferences if you like. I would be endlessly happy for everything!

Will add here to the News if I got something new :D
