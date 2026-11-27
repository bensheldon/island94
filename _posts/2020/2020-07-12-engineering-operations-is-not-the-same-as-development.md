---
date: '2020-07-12 18:42 -0700'
published: true
title: Engineering Operations is not the same as Development
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "c6f6140d2b0eb48d"
  vector: "+gIEAwD1AgQA/P8FBQEF/g748wAA//sG9QH29gD5AP8EAQMGCv4B+fXw9wv+9gX2/AH6/gP+/QIKBfgC/fz9BQIJ/fn+/fwB+QcCAP3/A/gB+vkJ/v8CAw3/Af0MAQsBBPj4BgIBAvYF9/r++/sAAv/4/gD5/AQGCAoB+AwCCgD+A/oIBfcB/wT5AAgH/A/+/g4IAwXr/gIFAvwJBAIC//wH/Qb59Af/8AH6CAMB//36/AMHDgD3/QbyAAMB/fcB+/cIAQP7AAIE/AD+Cf3//Qn6/v8GAQAC8w38AP4IBgD68PkJBPz99Qb57QD+/fD9/fwE/wEJ8gf+B+76APj8+gED/wQCBgQJCgD6A/4I+vv2BAUE//wAAwfy9g3/AAkHA/4EAfoDBPz5+AH+APvyA/4CAgX4BAUAAgDuBvQOAQABBAECCf8ABgUBCPv7BQcGAAHz/wgBAQAK+wMQCgb8/wAH+/oCAQEFAAcEBAEB7AMH+/77AxIFBQb5DwsAAAIF"
---
_I wrote this memo several years ago when I joined GetCalFresh as the first outside engineering hire. An early focus of mine was helping the team move more confidently into an operational mindset: this memo reframes the teams existing values that drive development as values that also support operations. This also overlaps greatly with a talk I gave at Code for America's 2018 Summit ["Keeping Users at the Forefront While Scaling Services"](https://speakerdeck.com/bensheldon/keeping-users-at-the-forefront-while-scaling-services)._

Over the past month GetCalFresh has tripled the number of food stamp applications we're processing. We often talk about "build the right thing", but I wanted to focus on what it means to "operate a thing safely".

## Understanding operational failure

GetCalFresh collects foodstamp applicant's information via a series of webforms, and then submits that applicant information to the county to begin the foodstamp eligibility process.

The website and webforms being offline or unavailable is **bad**.

Failing to submit application information to the county in a timely manner is **awful**. Foodstamp benefits are prorated to the day that the client's application arrives _at the county_ before 5pm. Failing to deliver a clients application in a timely manner literally means less food on the table for a hungry family.

Our system is operationally "safe" when it ensures that client information is transmitted to the county in a timely manner. Our system experiences an operational "failure" when information is not submitted in a timely manner. Our system has operational "risk" that degrades safety and is the potential for an operational failure.

## Risks in complicated, complex and chaotic systems

Keeping a website online is complicated, but can be addressed with good practice. We use boring technologies: Ruby on Rails, SQL, AWS, that scale and respond predictably and are part of a mature ecosystem of monitoring tools and practice.

Submitting client information to the county is complex and sometimes chaotic. Because county systems often have no API, we have a queue of jobworkers that use Selenium Webdriver to click through and type into a "virtualized" headless Firefox browser. Automating this leads to emergent and novel problems. Client data must be transformed into a series of scripted actions to be performed across multiple county webpages, with dynamic forms and data fields. The county websites may be offline or degraded, and occasionally their structure and content changes. Additional client documents may need to be faxed, emailed or uploaded to the county, and those systems can be degraded as well.

Our applicants themselves can cause operational risks. As we target new populations and demographics (e.g. seniors, students, military families, homeless, low-literacy or non-English-speaking), we discover new usability issues and challenges in collecting and transforming data from our webforms into county systems. For example, different county systems have different optional and required fields and expect names and addresses to by sanitized and tokenized differently.

In this system, we cannot reliably (or affordably, with time and resources) predict how this system will respond as it scales to new users or integrates with new counties.

## Creating safety with staff and time

We ensure that foodstamp applications are submitted in a timely manner through existing staff and dedicated time. Because we cannot reliably predict how our system scales or responds to changes, we have systems that alerts us to the risk of operational failure and engineers who are available to respond, remediate, and harden against similar circumstances in the future.

Every day, engineers block out 4pm to 5pm as "Apps & Docs". We use this time to review any food stamp applications that failed our automated submission process to ensure the applications are submitted to the county by the daily deadline. Problems are documented and potential improvements are added to or reprioritized within the team's backlog. We create safety by sometimes reaching out to clients for clarification or correction. In the event of an operational failure (we are not able to submit their application that day), we try to make things right; sometimes offering a gift card the client can use to purchase food.

Examples of problems identified during our hour of Apps & Docs:

- Services not allowing multiple parallel sessions using the same credentials.
- Inconsistent address tokenization for college campuses, military bases, PO boxes, and Private Mail Boxes
- Frequency of people uploading iexplore.exe and notes.app instead of their intended document
- Forms that do not allow non-ASCII characters
- Forever optimizing headless Firefox, writing flexible and reliable Selenium scripts, and managing an increasing fleet of specialized jobworkers

## Trade operational risk for speed of learning

We can't predict the exact operational issues we'll experience during a given day, but by scheduling and protecting one hour per day for operational tasks, we can deliberately trade risk for flexibility. Flexibility comes because we can accept small risks by introducing incomplete or manual-intervention-required workflows into the system. We do not have to build for every edge case or automate every action. We can develop features faster and create more opportunities to learn with real users in a real operational environment. This is an operationalization of our engineering principle "don't argue, ship".

## Takeaways

- **Define operational failure**: Leaving failure ambiguous can lead to fire-drills on every bad experience and exception, even if they may not have a material impact on business process or metrics. Defining service level objectives helps everyone self-organize, prioritize and understand the impact of their work.
- **Operationalize operations**: Unexpected things happen all the time, but merely saying "high priority interrupt" does not expose the actual cost of response and remediation. Blocking out explicit times and spaces helps measure, and thus manage, work that might otherwise be overlooked.
- **Protect Developers' time only so much**: "Any improvement not made at the constraint is an illusion." Approaching automation as an iterative and forever-incomplete process enables our team to move quickly in optimizing the system as a whole. When manual remediation is at risk of overflowing our time block, we dedicate time to greater automation; when we have perceived sufficient tolerances, we can push product features faster by manually tasking edge-cases.
- **Operations is a practice**: Product Design and Development principles and practice provide a strong foundation and an experienced team can greatly reduce the risk of technical and market failure... but they can't eliminate it. Operations is a field and practice that can reinforce and elevate Product Design and Development.
