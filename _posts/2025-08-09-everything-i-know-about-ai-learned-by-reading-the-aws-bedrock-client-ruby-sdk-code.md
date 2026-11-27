---
title: "Everything I know about AI, I learned by reading the AWS Bedrock Client Ruby SDK code"
date: 2025-08-09 21:28 UTC
published: true
tags: [Ruby on Rails, AI]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "7be772468391af54"
  vector: "8vv8AQ79AQcFA/QCCPsGBRH29P8EA/wA9Qf89gD5BQUEBv4LA/n9+f76/AAJ/v70/P7x+wYD/PsBBPkAAvUEAgYH+AQC/P7/+AIE/QUBCPT8AP8K+v/+BAgD+vYLAA0I/fb4BwANA/P//P0IAP39BQD6Cvz8AQwKBQYBBAn/+wACDP8NCPsBBQAG/A8DAgn69QUEAAnyAvwQ/gP8AwP5A/v+AP769v///gT7APgCBPz59wEDC/wD9v39BwIDAfsJAAP9Bwn8/wf5+P32//YBBfsD/wj//wL8+QD3/v/7/wD99vkFAvoBAAP+9vwB+v759fMHAP8H9QICBfMCAfr/+/z99ggHBf7+Cvz0/v7+9AgB/AD9+vz3AAgA/QX8/wL+AP0F//z/BPz6BQcGA/X4+f0DBgkSBwH//QHv//IL9gD7BwMGBQT/AwH7Avn3BwwLBf35/A4D+fwK/fsD/wUB/wEJCvv+9/8AAQn6Agr/9vUBBQD4ARQQAwjxBg8MAfwE"
---

*This essay is a little bit about me and how I solve problems, and a little bit about AI from the perspective of a software developer building AI-powered features into their product.*

The past week at my startup has been a little different. I spent the week writing a grant application [for](https://www.publicbenefitinnovationfund.org/summer-2025-open-call.html) “non-dilutive funding to accelerate AI-enabled solutions that help governments respond to recent federal policy changes and funding constraints in safety net programs.” It wasn’t particurly difficult, as we’re already deep into doing the work 💅 …but it was an interesting experience breaking that work down into discrete 250-word responses, all 17 (!) of them on the grant application.

One of my friends is a reviewer panelist (she’ll recuse herself from our proposal), and I was explaining my struggle to find an appropriate level of detail. Comparing an answer like:

> …we use AWS Bedrock models which are SOC, HIPAA, and Fedramp compatible, and integrated via its SDK which has robust guardrail functions like contextual grounding and output filters that we're using to ensure accuracy and safety when producing inferenced text output…

And:

> …we have robust controls for ensuring the safety and accuracy of AI-powered features…

That all might sounds like word salad anyways, so I compared it analogously to saying, in the context of web design:

> … we're designing our application using contemporary HTML and CSS features like media queries, and minimal Javascript via progress enhancement, to be usable and accessible across web browsers on devices from mobile phones to desktop computers….

And:

> ….mobile, responsive web design…

Working and communicating at the correct level of complexity _is the work_. While I’m developing software, I tend to be reductive; as the meme goes: *I’m not here to talk. Just put my [~~fries~~](https://knowyourmeme.com/editorials/guides/whats-the-just-put-my-fries-in-the-bag-bro-meme-the-viral-catchphrase-and-its-memes-on-tiktok-explained) http in the bag, bro. My DOM goes in the bag. Just put my Browser Security Model* in the bag.

I guess I have the benefit of perspective, working in this field for 20+ years. While things have gotten to layer-upon-layer complexity, I can remember what simple looks and feels likes. It’s also _never_ been simple.

For example, in the civic tech space, there’s been lots of times where on one side someone wants to talk about civic platforms and government vending machines and unleashing innovation, and on the other side is a small room with vendor representative that is existentially opposed to adding a reference field to a data specification without which the whole system is irreconcilably unusable. The expansive vision and the tangible work.

I believe, at the core of all of this IT (Information Technology (or ICT, Information and Communications Technology as it’s known globally), we’re doing [pushing Patrick](https://knowyourmeme.com/memes/push-it-somewhere-else-patrick): take information from one place, *and we push it somewhere else*.

![Push it Patrick GIF](/uploads/2025/push-it-patrick.gif)

Take that information from a person via a form, from a sensor, from a data feed, from a process, *and push it somewhere else*. Sure, we may enrich and transform it and present it differently, and obviously figuring out what is useful and valuable and useable is _the work_. From the backend to the frontend, and the frontend to the backend. From client to server, from server to server, protocol to protocol, over, under, you get the idea. The work is _pushing information somewhere else_.

**Anyways, about that AI...**

From Brian Merchant’s Blood in the Machine newsletter, describing going to an [AI retreat thing](https://www.bloodinthemachine.com/p/ai-disagreements):

> I admittedly had a hard time with all this, and just a couple hours in, I began to feel pretty uncomfortable—not because I was concerned with what the rationalists were saying about AGI, but because my apparent inability to occupy the same plane of reality was so profound. In none of these talks did I hear any concrete mechanism described through which an AI might become capable of usurping power and enacting mass destruction, or a particularly plausible process through which a system might develop to “decide” to orchestrate mass destruction, or the ways it would navigate and/or commandeer the necessary physical hardware to wreak its carnage via a worldwide hodgepodge of different interfaces and coding languages of varying degrees of obsolescence and systems that already frequently break down while communicating with each other.

I mean… exactly. Like what even.

From my own experience of writing that grant application I mentioned at the beginning of this post, and enumerating all of the AI-powered features that we’ve built already, are prototyping, or confidently believe we can deliver in the near-term future… it’s quite a lot. And it’s not that different from anything that’s come before: building concrete stuff that concretely works. I wrote [something similar](https://island94.org/2025/01/how-im-thinking-about-ai-llms) back in January too, so maybe this feeling is here to stay.

The places where I struggled most to write about was in how many places, about trust and safety and risk and capacity... was explaining how we’re using functions that are quite simply exposed via the SDK. AWS Bedrock is how Amazon Web Services provides AI models as a billable resource developers can use. The SDK is how you invoke those AI models from your application. *Just put the method signature in the bag.* It’s all documented: the `#converse_stream` method, pretty much the only method to use: no joke, has [1003 lines of documentation above it describing all of the options to pass, and and all of the data that gets returned](https://github.com/aws/aws-sdk-ruby/blob/208a24482111145a209ff0a4a8fedf7a802b6993/gems/aws-sdk-bedrockruntime/lib/aws-sdk-bedrockruntime/client.rb#L1583-L2587):

- Providing an inference prompt
- Attaching documents
- Tool usage, which is how models can coerced to produce structured output
- Contextual grounding, to coerce the model to use context from the input rather than its foundational training sources.
- Guardrails and safety filters, to do additional checks on the output, sometimes by other models.
- …and all of the limitations and constraints that are very _real_ and _tangible_. By which I mean the maximum number of items one can send in an array or the maximum number of bytes that can be sent as a base64-encoded string.

Every option is very concretely about passing a simple hash of data in, and getting a hash of data out. *Just put the Ruby Hash in the bag.*

To analogously compare this to one of the oldest and boringest AWS services, the Simple Storage Service, there is, with one hand, waving about how “the capability to store and retrieve an unlimited amount of data will change the world” and, and then with the other hand precisely “overriding the Content-Type of an S3 file upload”. Reading the method signature is the latter.

And I don’t mean to imply everything in that 1003 line docblock is all you need to know. But you might wonder, say “When might I want to get a `resp.output.message.content[0].citations_content.citations #=> Array`?” and then you google it and go down a rabbit hole to learn that citations are just another form of tool usage and _[sometimes the model won't do it](https://repost.aws/questions/QUKwoMWVdCRQ6Y_drrZNXZPg/how-to-have-a-bedrock-agent-reliably-include-knowledge-base-citations-in-the-final-response-of-invokeagent-for-agents-for-amazon-bedrock-runtime)_ which if you keep digging down that rabbit hole everything becomes evident that these are, at heart, still probabilistic text generators that are useful and interesting _in the same way S3 is useful and interesting, and also isn’t._ It’s a totally different conversation.

So, if there’s any takeways to be had here:

- This stuff is as boringly useful as any other AWS service is or isn’t, if you’re familiar with the vast number of AWS services.
- It’s maybe embarrassing to write about in tangible form because it’s already been boringly commodified as a service through AWS.
- …and also there are tangible, useful things to be built. And a lot of intellectual joy in breaking down how some high-level feature is built on top of these low-level services.

My self-serving interest here is that I’d love to talk to other folks who are building stuff in Ruby on Rails using AI and LLMs and inference about the boring stuff involved in *taking information from one place, and pushing it somewhere else.*

For example, yesterday I posted in the [Ruby on Rails Link Slack](https://www.rubyonrails.link/) `#ai-lounge` channel:

> Anyone building AI-powered features into their application? I’ve got an interface for translating a text field into another language, and I was curious if anyone has a pattern they like with Turbo/ActionCable/Stimulus for streaming responses to a particular form for a single client (e.g. there’s not yet a model record that can be broadcasted from). This is what I’m doing (hopefully it makes sense 😅) ...

...and I'm waiting for a response.
