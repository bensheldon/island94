---
title: Engineering Practice Ad nauseam
date: 2017-01-30 04:22 UTC
tags:
  - software engineering
  - boil the ocean
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "2f4aff333df1239d"
  vector: "+/37AgP5/wf8BPUHA/4H/Qb3Afv4//8H9AD//P3x/AYHA/wNCP0A+vj5+AAF9QH4/AD48QL+/QcG///5Af/3Bf/+/QgA+/n9+/4C/gIAB/kDBfkS+wEDCAUAAf8F/gAEA/gDCgMAB/r3AwAFAgT7Aff4C/32AwwEBg0I+AwLAQD+CPkQBAECBPv/BxH/Aw31+QoDAPzz/QoO/wIG/wIEAAH+/QX08wb+8gL1AAECAv8D//v/EQn//wzzAwAAA/YBAP4AAwv5+AMEAf75+AICBPoG/wAM/wYD+g7+AwQLAAAA/f4OC/n++gf6+vz7A/f7/fL//gEJ+AL8Avf8//kD/AT/+/z/AAMGB/0A/P8H+P7z+v8B/fUB/AL6+QgIAwYG/foEBPUB+f/4+wD89/L///kC/gf9DP8AAvrx+/UEAwD5AwL+Af//BQkCAvv2CgsC+w708gcGAP4F+QAIBP4DAQQBAvsDAg8M+wkCBfUA8wX28QD9Ag0JCgr9BQUG+/8J"
---


I came up with this list to spark peer-led initiatives on an engineering team. Originally I used it to work with a team to define "ideal practice", "current practice", and then identify distinct "projects" to close the gap. The examples here are to help explain what I'm describing and are probably not the ideal state.

## Frontend

Frontend engineering is unique because the engineer has relatively little control over the environment or human context in which their applications are run and used.

- Browser compatibility: Having a standard; reviewed regularly? Based on real user data from GA. SCSS Autoprefixer
- Real user monitoring (performance, bandwidth/api latency): using Fullstory and New Relic. Having a performance budget / SLO. Having “key transactions” for monitoring
- Browser exception monitoring: Sentry with sourcemaps
- Viewport / responsive design: Standards, device lab, browserstack assertions, etc.
- Usability: Heatmaps, User observation, Usability interviews, clear activation metrics, etc
- Accessibility: Accessibility Standards and Linting. People care about accessibility. Technical staff are proficient with Voiceover
- Customer interaction: Confidence and knowledge to have public conversations with customers and support them. Self-directed teams that understand the product well enough that they can take and manage customer feedback

## Backend

The services that do the work.

- Services, Responsibilities and Boundaries: Monoliths, SOA, Microservices, how you slice the problem.
- Data storage: SQL/NoSQL, cache (Redis), index (ES, Solr), etc
- Database Querying: Getting the data, N+1s, Views, indexing
- Asynchronous Operations: job workers, notifications/messaging, ETLs, scheduled emails, generated reports

## Development and Collaboration

A technically complex team sport.

- Packaging and build pipeline: Up-to-date build tooling. Containerized and artifacted, roll-backable, and promotable. Live code reloading. JS/CSS packaging
- Source code management and sharing: The source is committed to a Git repository and uploaded to GitHub. Code Review on PRs. File naming and organization conventions; practice of removing unused code.
- Dependency management: Dependencies are regularly updated. Considering breaking out things into modules. Having a standard for out-of-date updates. Dependency risk review (availability, security, do-we-need-it). Gemnasium, etc.
- API Design: Client systems (front and backend) have something to talk to. Available and complete documentation, messages attached to API calls should be coherent. Design is part of some standard process
- Continuous Integration: CI server; automated tests. Regularly review runtime. Regularly reviews and automates manual tasks
- Testing: Testing is easy. Visual regression. Acceptance testing as part of a team. Code coverage is tracked and managed.
- Philosophy of personal productivity: Automation vs just doing it. Consensus on that XKCD cartoon about how long something takes. "Maker hours" and review of happiness/productivity. Time tracking, etc.
- Philosophy of team productivity: Meetings and collaboration across departments and functions. Process for managing the process of change.

## Project Management and Acceptance

Within complex systems - both human and technical - it’s difficult to ensure that the work being done is the right work to be done. On the business level, certain parts of the system, especially visual-facing, may unduly affect perception of the overall system.

- Management philosophy: Scrum, kanban, theory of constraints
- Management practice (running standup, demos, retros, architectural planning): Concise Agenda, Clear outcomes, well-facilitated. Come prepared. Meeting Templates. Clear reason why in and having the meeting
- Management tools (Jira, Trello, sticky notes): Visually track the flow of work through the organization
- Code and standards reviews: Enforce standards with automation. Regularly scheduled as part of project
- Collateral and hand-offs: Collab with Product, Design and Ops. Clear templates and cross-checks; Wire frames over pixel-perfect mockups.
- Acceptance and demos: Feature Flagging; Staging Environment. Standard handoff process.
- Estimating and Prediction: Have a high-level view of process. Be able to make and communicate estimates satisfactorily and/or accurately.
- Managing and prioritizing product feedback: Can receive feedback efficiently and route/evaluate/prioritize. Balances functions between Product, Design and Engineering.

## Delivery and Operations

- Asset hosting and CDNs: Quick, reliable, and caches don't ruin your day ("you'll have to clear your cache")
- Service monitoring (deliverability, consistency, verification): Healthchecks; SLO; Pagerduty; thresholds; frog boils.
- Security: https, XSS, Pentests, Bugbounties, responsible disclosure, Human/asset management
- Business Continuity: Backups, Domain name and certificate renewals, multi-datacenter, hit-by-a-bus problems
- Dependency and vulnerability management philosophy: Scheduling reviews/updates
- Incident Command and Management: Roles and responsibilities, SLAs, incident reporting, play/run-books
- Bugs and regression management: identification, prioritization, prevention
- Marketing/activity/metrics tracking: Practice (tag management) and Process (can easily report out biz analysis numbers without heroics)

## Standardization and Innovation

Web engineering, as the intersection of several different domains and technologies (e.g. HTML, CSS, JavaScript, browsers, backends, PaaS, etc.) rapidly innovates along multiple dimensions. These are strategies for managing change.

- Frameworks (e.g. Rails) & conventions (e.g. BEM): Use open source community maintained framework/standards vs NIH; unique business case attitude
- Standards and style guides: Have coding practice/styleguides and ratification process
- Linting: Have coding practice/styleguides and ratification process
- Proof of Concepting: Be quicker to use to validate and overcome decision avoidance. Quantity of work that is thrown away.
- Architecture and system strategy: Long term technical vision and alignment with external forces and opportunities

## Stewardship and Advancement

Ensure a healthy and growing environment exists for technical practitioners to professionally advance and spread the good news.

- Onboarding and orientation of new hires and practitioners
- Career advancement path
- Industry Leadership: public speaking, publishing, being a leader in the field
