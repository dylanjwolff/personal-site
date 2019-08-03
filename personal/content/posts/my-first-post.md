---
title: "Programming Paradigms and the Jam Problem"
date: 2019-08-02T22:35:07+02:00
draft: true
---
Aziz Ansari has a bit in his book "Modern Love" (which, full disclosure, I have not read) where he compares the online dating scene to walking into a sort of hellish jam-emporium. He notes that the overwhelming amount of almost meaningless differences between the tens of thousands of types of jam ultimately detracts from the jam-buying experience. Indeed, if Mrs. Jam had provided a curated list of only a select few types of jam, even if there were other jams out there that might be just as good as those ten, the overall experience for the jam consumer is better for not having the cognitive load of processing all possible jam types and combinations. Indeed, this one reason that higher end restaurants have shorter menu's than Jim's Deli.

Programming is like buying jam from the jam emporium.

As any reasonably experienced software engineer knows, there are many different ways to solve a problem. There are different paradigms, languages, stules, and algorithms that all could be used to accomplish the same task. Some of these approaches will be objectively better or worse than others for a given task: writing your next application as 10000 lines of spagetti code in a single COBOL with a bunch of GOTO's is probably suboptimal in 2019. For others the value proposition is less clear. Still, there are constantly debates, both healthy and unhealthy, as to what the "best" way to do something is.

After a great amount of reflection on my own experience, dicussion with others, and click-baity Hacker News articles, my conclusion is this:

(To a large extent) it doesn't fucking matter what kind of jam you buy.

Sure, if you buy the shrimp and chocolate flavored jam, it's probably going to be terrible, and you'd have only yourself to blame. But is the strawberry jam better than the raspberry jam? Who knows! It's really a matter of opinion, but chances are, if they are both popular jam flavors, they are both going to be fine. And really, you can't know whether or not you like the jam until you actually try it (there are nor free samples at the jam emporium). Translated to programming: it's reasonable to avoid obvious pitfalls when making design decisions, but past a certain point, the ramifications of those decisions aren't worth the cognitive load of making them.

Which brings me to the obligatory OO bashing section of any random blog post about programming in 2019:

(In my opinion) OO Design exacerbates the jam problem far more than other paradigms

Consider a simple object that wants to send a message. Already, we have many questions: should the message have a send method that we just call from the object? Should the object itself have a send method that takes in a message and then sends it? Should there be a MessageManager that does the sending for us? While most OOP buffs would probably say that the third approach is probably most aligned with the SRP pinciple, it also adds complexity to a very simple system. Ultimately we'd need to know more about the requirements of the system to determine the "right" approach.

Worrying about this is (generally) a waste of time!

I think a lot of the problem actually boils down to grammar. OOP has the really nice quality that it reads like an English sentence:

sender.send(message, recipient) // The sender sends the message to the recipient

But imposing which component of a system is the "subject" is almost always a false dichotomy when it comes to programming anything beyond simple toy examples. In most cases, it doesn't matter who the subject is, and the time spent figuring out which object is the subject of a given action is not worth the marginal architectural gains of doing so. And yet decisions like this result in hours of senior developers bikeshedding away time and time again at meeting after meeting over weeks, or even months, to get the architecture just right when a university student could hack together a prototype with a little guidance in a day or two.

Just buy the damn jam already.
