from reportlab.lib.pagesizes import letter
from reportlab.lib.units import inch
from reportlab.lib.colors import HexColor
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, HRFlowable
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.enums import TA_CENTER, TA_LEFT
import os

output_path = '/sessions/nifty-adoring-turing/mnt/MakinMoves/products/cold_email_kit/Cold_Email_Outreach_Kit_for_Freelancers.pdf'
os.makedirs(os.path.dirname(output_path), exist_ok=True)

doc = SimpleDocTemplate(output_path, pagesize=letter,
    topMargin=0.7*inch, bottomMargin=0.7*inch,
    leftMargin=0.8*inch, rightMargin=0.8*inch)

styles = getSampleStyleSheet()

BLUE = HexColor('#2D5AA0')
DARK = HexColor('#1B2A4A')
LIGHT = HexColor('#F0F4F8')
AMBER = HexColor('#F9A825')

styles.add(ParagraphStyle('CTitle', parent=styles['Title'], fontSize=26, leading=32, textColor=DARK, alignment=TA_CENTER, spaceAfter=10))
styles.add(ParagraphStyle('CSub', parent=styles['Normal'], fontSize=13, leading=17, textColor=HexColor('#555'), alignment=TA_CENTER, spaceAfter=6))
styles.add(ParagraphStyle('SectionH', parent=styles['Heading1'], fontSize=18, leading=22, textColor=BLUE, spaceBefore=16, spaceAfter=8))
styles.add(ParagraphStyle('TemplateH', parent=styles['Heading2'], fontSize=14, leading=18, textColor=DARK, spaceBefore=12, spaceAfter=6))
styles.add(ParagraphStyle('Body', parent=styles['Normal'], fontSize=10.5, leading=15, textColor=HexColor('#333'), spaceAfter=6))
styles.add(ParagraphStyle('EmailBox', parent=styles['Normal'], fontSize=10, leading=14.5, textColor=DARK, leftIndent=10, rightIndent=10))
styles.add(ParagraphStyle('Tip', parent=styles['Normal'], fontSize=9.5, leading=13, textColor=HexColor('#0D652D'), spaceAfter=6, leftIndent=10))
styles.add(ParagraphStyle('Label', parent=styles['Normal'], fontSize=9, leading=12, textColor=HexColor('#FFF'), alignment=TA_CENTER))
styles.add(ParagraphStyle('CTA', parent=styles['Normal'], fontSize=13, leading=17, textColor=BLUE, alignment=TA_CENTER, spaceBefore=10, spaceAfter=8))

def email_block(subject, body, tip=None):
    elements = []
    content = f"<b>Subject:</b> {subject}<br/><br/>{body}"
    t = Table([[Paragraph(content, styles['EmailBox'])]], colWidths=[5.8*inch])
    t.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), LIGHT),
        ('BOX', (0,0), (-1,-1), 1, HexColor('#CBD5E1')),
        ('TOPPADDING', (0,0), (-1,-1), 10),
        ('BOTTOMPADDING', (0,0), (-1,-1), 10),
        ('LEFTPADDING', (0,0), (-1,-1), 12),
        ('RIGHTPADDING', (0,0), (-1,-1), 12),
    ]))
    elements.append(t)
    if tip:
        elements.append(Spacer(1, 4))
        elements.append(Paragraph(f"<b>Pro tip:</b> {tip}", styles['Tip']))
    return elements

story = []

# COVER
story.append(Spacer(1, 1.2*inch))
story.append(Paragraph("Cold Email Outreach Kit<br/>for Freelancers", styles['CTitle']))
story.append(Spacer(1, 0.2*inch))
story.append(HRFlowable(width="35%", thickness=2, color=BLUE))
story.append(Spacer(1, 0.2*inch))
story.append(Paragraph("25 copy-paste email templates to land clients,<br/>close deals, and get paid on time.", styles['CSub']))
story.append(Spacer(1, 0.4*inch))

toc_items = [
    "Section 1: Cold Outreach (5 templates)",
    "Section 2: Follow-Up Sequences (5 templates)",
    "Section 3: Proposals & Pricing (5 templates)",
    "Section 4: Client Win-Back & Referrals (5 templates)",
    "Section 5: Objection Handlers (5 templates)",
]
toc_data = [[Paragraph(f"<b>{item}</b>", styles['Body'])] for item in toc_items]
toc = Table(toc_data, colWidths=[4.5*inch])
toc.setStyle(TableStyle([
    ('BACKGROUND', (0,0), (-1,-1), HexColor('#F8F9FA')),
    ('BOX', (0,0), (-1,-1), 1, BLUE),
    ('INNERGRID', (0,0), (-1,-1), 0.5, HexColor('#DEE2E6')),
    ('TOPPADDING', (0,0), (-1,-1), 6),
    ('BOTTOMPADDING', (0,0), (-1,-1), 6),
    ('LEFTPADDING', (0,0), (-1,-1), 14),
]))
story.append(toc)
story.append(Spacer(1, 0.5*inch))
story.append(Paragraph("outdoorphunk.gumroad.com", styles['Tip']))
story.append(PageBreak())

# HOW TO USE
story.append(Paragraph("How to Use This Kit", styles['SectionH']))
story.append(Paragraph("Each template has <b>[BRACKETS]</b> where you fill in your details. The rest is ready to send. Here's how to get the most out of them:", styles['Body']))
story.append(Spacer(1, 6))
tips_data = [
    ["1.", "Customize once, reuse forever. Replace [YOUR SPECIALTY] in all templates upfront."],
    ["2.", "Don't send all 5 cold outreach templates to the same person. Pick the one that fits."],
    ["3.", "Follow the sequence: Cold Outreach > Follow-Up Day 3 > Follow-Up Day 7 > Breakup."],
    ["4.", "Personalize the first line. One specific detail about their business doubles response rates."],
    ["5.", "Send between 8-10 AM in their timezone. Tuesday-Thursday gets the best open rates."],
]
for row in tips_data:
    story.append(Paragraph(f"<b>{row[0]}</b> {row[1]}", styles['Body']))
story.append(PageBreak())

# SECTION 1: COLD OUTREACH
story.append(Paragraph("Section 1: Cold Outreach", styles['SectionH']))
story.append(Paragraph("First-touch emails for prospects who don't know you yet. Each template uses a different angle.", styles['Body']))

story.append(Paragraph("Template 1: The Value-First Approach", styles['TemplateH']))
story += email_block(
    "Quick idea for [COMPANY NAME]'s [blog/website/emails]",
    "Hi [NAME],<br/><br/>I was looking at [COMPANY]'s [specific thing you noticed — blog, landing page, email sequence] and had a few ideas that could [specific benefit — drive more signups, improve SEO rankings, convert more visitors].<br/><br/>I'm a freelance [YOUR SPECIALTY] and I've helped similar companies in [THEIR INDUSTRY] [specific result — e.g., increase blog traffic 40% in 3 months].<br/><br/>Would it be worth a 15-minute call this week to see if there's a fit?<br/><br/>Best,<br/>[YOUR NAME]",
    "Replace \"a few ideas\" with 1 actual specific idea. Specificity = credibility."
)

story.append(Paragraph("Template 2: The Observation Approach", styles['TemplateH']))
story += email_block(
    "Noticed something about [COMPANY]'s [content/site/campaigns]",
    "Hi [NAME],<br/><br/>I've been following [COMPANY] for a while and noticed [specific observation — e.g., your blog hasn't been updated since January, your landing page copy could be stronger, your email sequence drops off after the welcome].<br/><br/>That's usually a sign that [pain point — content team is stretched thin, copywriting isn't the priority right now, there's no dedicated person handling it].<br/><br/>I help [THEIR INDUSTRY] companies fix exactly that. Would it make sense to chat for 15 minutes about what you're working on?<br/><br/>[YOUR NAME]",
    "The observation must be real and specific. Generic observations get deleted."
)

story.append(PageBreak())
story.append(Paragraph("Template 3: The Social Proof Approach", styles['TemplateH']))
story += email_block(
    "How [SIMILAR COMPANY] [achieved specific result] with freelance [your specialty]",
    "Hi [NAME],<br/><br/>I recently helped [SIMILAR COMPANY/INDUSTRY] [specific result — e.g., rewrite their product pages, which increased demo requests by 25%].<br/><br/>[COMPANY] is in a similar space, and I think some of the same approaches could work for you — especially around [specific area you'd target].<br/><br/>Happy to share what worked and see if it applies. Free 15-min call this week?<br/><br/>[YOUR NAME]",
    "If you don't have a case study yet, use: \"I've seen companies like yours get results by...\" — frame expertise, not client names."
)

story.append(Paragraph("Template 4: The Question Approach", styles['TemplateH']))
story += email_block(
    "Quick question about [COMPANY]'s content strategy",
    "Hi [NAME],<br/><br/>Who handles [content/copy/design] at [COMPANY] right now? I ask because I noticed [specific gap — e.g., your competitors are publishing 3x more content, your landing pages could be converting better].<br/><br/>I work with [THEIR INDUSTRY] companies on exactly this. If it's on your radar, I'd love 15 minutes to share what I'm seeing in your space.<br/><br/>No pressure either way.<br/><br/>[YOUR NAME]",
    "Starting with a question gets 2x the response rate of starting with a statement."
)

story.append(Paragraph("Template 5: The Mutual Connection Approach", styles['TemplateH']))
story += email_block(
    "[MUTUAL CONNECTION] suggested I reach out",
    "Hi [NAME],<br/><br/>[MUTUAL CONNECTION] mentioned you might be looking for help with [specific need]. I'm a freelance [YOUR SPECIALTY] and I've worked with [similar companies/in their industry] on [relevant projects].<br/><br/>[One sentence about a relevant result you've achieved.]<br/><br/>Would a quick 15-minute call make sense this week?<br/><br/>[YOUR NAME]",
    "Even a loose connection works: \"I saw your comment in [community]\" or \"We both follow [person].\""
)

story.append(PageBreak())

# SECTION 2: FOLLOW-UP SEQUENCES
story.append(Paragraph("Section 2: Follow-Up Sequences", styles['SectionH']))
story.append(Paragraph("Most deals close on the follow-up, not the first email. Use these in order after a cold outreach.", styles['Body']))

story.append(Paragraph("Template 6: Day 3 Follow-Up (Gentle Nudge)", styles['TemplateH']))
story += email_block(
    "Re: [Original subject line]",
    "Hi [NAME],<br/><br/>Just floating this back up — I know [DAY OF WEEK]s can be busy.<br/><br/>The short version: I help [THEIR INDUSTRY] companies with [YOUR SPECIALTY], and I think there's a quick win around [specific thing you mentioned in first email].<br/><br/>Worth a 15-minute call? I'm open [two specific time slots].<br/><br/>[YOUR NAME]",
    "Reply to your original thread — don't start a new one. It shows persistence, not spam."
)

story.append(Paragraph("Template 7: Day 7 Follow-Up (Add Value)", styles['TemplateH']))
story += email_block(
    "Found this and thought of [COMPANY]",
    "Hi [NAME],<br/><br/>Came across [relevant article/stat/trend] about [their industry] and thought of your team.<br/><br/>[One sentence summarizing the insight and why it matters for them.]<br/><br/>If you're thinking about [the problem you solve], I'd love to compare notes. 15 minutes this week?<br/><br/>[YOUR NAME]",
    "Adding value on the follow-up separates you from every other cold emailer."
)

story.append(Paragraph("Template 8: Day 14 Follow-Up (Direct Ask)", styles['TemplateH']))
story += email_block(
    "Still interested in improving [COMPANY]'s [area]?",
    "Hi [NAME],<br/><br/>I've reached out a couple times about helping [COMPANY] with [YOUR SPECIALTY]. Want to make sure I'm not cluttering your inbox if the timing isn't right.<br/><br/>Two quick options:<br/>A) Let's find 15 min to talk — I think I can help.<br/>B) Not the right time — no hard feelings, I'll check back in a few months.<br/><br/>Either way, just hit reply and let me know.<br/><br/>[YOUR NAME]",
    "The A/B format makes it easy to respond even if the answer is no."
)

story.append(PageBreak())
story.append(Paragraph("Template 9: Breakup Email (Last Touch)", styles['TemplateH']))
story += email_block(
    "Closing the loop",
    "Hi [NAME],<br/><br/>I've sent a few notes about helping [COMPANY] with [YOUR SPECIALTY] and haven't heard back, so I'll assume the timing isn't right.<br/><br/>I'm going to close this out on my end. If things change down the road, you know where to find me.<br/><br/>Wishing you and the team a great [quarter/season].<br/><br/>[YOUR NAME]",
    "Breakup emails get a 30-40% response rate. People hate the feeling of closing a door."
)

story.append(Paragraph("Template 10: Re-Engage (3 Months Later)", styles['TemplateH']))
story += email_block(
    "Checking back in — [COMPANY] + [YOUR SPECIALTY]",
    "Hi [NAME],<br/><br/>We connected briefly a few months ago about [YOUR SPECIALTY] for [COMPANY]. Wanted to check back in and see if [the need you identified] is still on your radar.<br/><br/>Since then, I've [new achievement or credential — e.g., completed a similar project, published relevant work, added a new service].<br/><br/>If you're planning [relevant initiative] for [upcoming quarter], I'd love to chat. If not, no worries — I'll check back later.<br/><br/>[YOUR NAME]",
    "Set a calendar reminder to re-engage at 3 and 6 months. Some of your best clients will come from long nurture cycles."
)

story.append(PageBreak())

# SECTION 3: PROPOSALS & PRICING
story.append(Paragraph("Section 3: Proposals & Pricing", styles['SectionH']))
story.append(Paragraph("Emails for the deal-closing phase. After the call, send one of these.", styles['Body']))

story.append(Paragraph("Template 11: Project Proposal Email", styles['TemplateH']))
story += email_block(
    "Proposal: [PROJECT NAME] for [COMPANY]",
    "Hi [NAME],<br/><br/>Thanks for the great conversation [today/yesterday]. Here's what I'm proposing based on our discussion:<br/><br/><b>Project:</b> [DELIVERABLE DESCRIPTION]<br/><b>Timeline:</b> [X] business days from kickoff<br/><b>Deliverables:</b> [SPECIFIC LIST]<br/><b>Investment:</b> $[AMOUNT] (50% upfront, 50% on delivery)<br/><b>Includes:</b> [REVISION ROUNDS], [OTHER INCLUSIONS]<br/><br/>If this looks good, just reply \"approved\" and I'll send the invoice for the first half. We can kick off within 24 hours of payment.<br/><br/>Happy to adjust anything — let me know.<br/><br/>[YOUR NAME]",
    "\"Reply approved\" is a micro-commitment that's easier than signing a contract. Save the formal agreement for larger deals."
)

story.append(Paragraph("Template 12: Retainer Pitch", styles['TemplateH']))
story += email_block(
    "Monthly [YOUR SPECIALTY] retainer — [COMPANY]",
    "Hi [NAME],<br/><br/>Now that we've wrapped [PREVIOUS PROJECT], I wanted to suggest something that might make more sense going forward.<br/><br/>Instead of project-by-project pricing, a monthly retainer gives you:<br/>- Predictable costs (same amount every month)<br/>- Priority access (your work goes to the front of my queue)<br/>- Better rates (retainer pricing is [X]% less than project rates)<br/><br/><b>What's included:</b> [SPECIFIC DELIVERABLES PER MONTH]<br/><b>Investment:</b> $[AMOUNT]/month<br/><b>Term:</b> Month-to-month (cancel anytime with 30 days notice)<br/><br/>This is what most of my long-term clients switch to after the first project. Want to give it a try for a month?<br/><br/>[YOUR NAME]",
    "Pitch retainers after a successful first project, never before. The trust has to be earned."
)

story.append(PageBreak())
story.append(Paragraph("Template 13: Rate Increase Notice", styles['TemplateH']))
story += email_block(
    "Heads up: rate adjustment starting [DATE]",
    "Hi [NAME],<br/><br/>Quick heads up — I'll be adjusting my rates starting [DATE, at least 30 days out]. My new rate for [SERVICE] will be $[NEW RATE] (currently $[OLD RATE]).<br/><br/>This reflects [brief reason — increased demand, expanded expertise, market adjustment]. I wanted to give you plenty of notice.<br/><br/>For existing clients like you, I'm happy to lock in the current rate for any work we book before [DATE]. After that, new projects will be at the updated rate.<br/><br/>Let me know if you have questions or want to book anything at the current rate.<br/><br/>[YOUR NAME]",
    "Raise rates once a year minimum. Grandfathering existing clients for 30-60 days softens the blow and often accelerates bookings."
)

story.append(Paragraph("Template 14: Scope Change / Change Order", styles['TemplateH']))
story += email_block(
    "Scope update for [PROJECT NAME]",
    "Hi [NAME],<br/><br/>Love the direction of your latest feedback. The changes you're describing go a bit beyond our original scope, so I want to make sure we're aligned before I proceed.<br/><br/><b>Additional work:</b> [DESCRIPTION]<br/><b>Additional investment:</b> $[AMOUNT]<br/><b>Updated timeline:</b> [NEW DEADLINE]<br/><br/>If that works, just reply \"go ahead\" and I'll get started. If you'd prefer to stay with the original scope, the current version is ready for final delivery.<br/><br/>Either way works for me — just want to be transparent about what's involved.<br/><br/>[YOUR NAME]",
    "Send this the MOMENT scope creep starts, not after you've already done the extra work."
)

story.append(Paragraph("Template 15: Invoice Reminder (Friendly)", styles['TemplateH']))
story += email_block(
    "Invoice [#NUMBER] — quick reminder",
    "Hi [NAME],<br/><br/>Just a quick reminder that invoice [#NUMBER] for $[AMOUNT] was due on [DATE]. If you've already sent it, please disregard!<br/><br/>Payment link: [LINK]<br/><br/>Let me know if you need anything from my end to process it.<br/><br/>Thanks,<br/>[YOUR NAME]",
    "Send this on Day 1 past due. Don't wait a week hoping they'll remember."
)

story.append(PageBreak())

# SECTION 4: WIN-BACK & REFERRALS
story.append(Paragraph("Section 4: Client Win-Back & Referrals", styles['SectionH']))

story.append(Paragraph("Template 16: Past Client Re-Engagement", styles['TemplateH']))
story += email_block(
    "Been a while — how's [COMPANY] doing?",
    "Hi [NAME],<br/><br/>It's been [X months] since we wrapped [PREVIOUS PROJECT]. Hope things are going well at [COMPANY].<br/><br/>I was thinking about your [content/copy/design] and wondered if [specific opportunity — e.g., you're planning a Q2 content push, your website could use a refresh for the new product launch].<br/><br/>I've got some availability opening up in [TIMEFRAME]. If there's anything on your radar, I'd love to help again.<br/><br/>Either way, hope you're doing well.<br/><br/>[YOUR NAME]",
    "Re-engaging past clients is 5x cheaper than acquiring new ones. Set quarterly reminders."
)

story.append(Paragraph("Template 17: Referral Ask (After Positive Feedback)", styles['TemplateH']))
story += email_block(
    "Quick favor?",
    "Hi [NAME],<br/><br/>Really glad to hear [positive thing they said about your work]. That kind of feedback means a lot.<br/><br/>Quick ask: do you know anyone else who might need [YOUR SPECIALTY]? I'm taking on [1-2] new clients this month and your referral would mean the world.<br/><br/>No pressure at all — just thought I'd ask since we've had such a great experience working together.<br/><br/>Thanks,<br/>[YOUR NAME]",
    "Ask within 48 hours of receiving positive feedback. That's when goodwill is highest."
)

story.append(Paragraph("Template 18: Testimonial Request", styles['TemplateH']))
story += email_block(
    "Would you mind sharing a quick testimonial?",
    "Hi [NAME],<br/><br/>I'm updating my portfolio and would love to include our work together. Would you be open to sharing a brief testimonial?<br/><br/>If it helps, here's a starting point you can edit however you'd like:<br/><br/><i>\"[YOUR NAME] helped us with [PROJECT]. The result was [OUTCOME]. I'd recommend them for anyone who needs [YOUR SPECIALTY].\"</i><br/><br/>Feel free to change anything — even a 1-2 sentence version would be great. And if you'd prefer not to, totally understand.<br/><br/>Thanks,<br/>[YOUR NAME]",
    "Giving a draft template 3x the response rate. People want to help but don't want to write from scratch."
)

story.append(PageBreak())
story.append(Paragraph("Template 19: Upsell After Delivery", styles['TemplateH']))
story += email_block(
    "One more idea for [COMPANY]",
    "Hi [NAME],<br/><br/>Now that [DELIVERABLE] is live, I noticed an opportunity that could build on the momentum:<br/><br/>[SPECIFIC IDEA — e.g., \"Your new blog posts would perform even better with a monthly email newsletter driving traffic to them\" or \"A landing page refresh would complete the messaging overhaul we started\"].<br/><br/>No pressure — just wanted to plant the seed. If it's interesting, we could scope something out. If not, enjoy the new [deliverable]!<br/><br/>[YOUR NAME]",
    "The best time to upsell is right after a successful delivery. The client is happy and trusts you."
)

story.append(Paragraph("Template 20: Referral Thank You (When Someone Refers a Client)", styles['TemplateH']))
story += email_block(
    "Thank you — [REFERRED PERSON] reached out!",
    "Hi [NAME],<br/><br/>[REFERRED PERSON] just got in touch and mentioned you sent them my way. Thank you — that means a lot coming from you.<br/><br/>I'll take great care of them. And as a thank you, [your referral gesture — e.g., I'd love to send you a $50 gift card, I'll give you a discount on your next project, I owe you a coffee].<br/><br/>Seriously, thank you. Referrals from happy clients are the best way I grow my business.<br/><br/>[YOUR NAME]",
    "Always close the loop on referrals. It trains people to keep referring."
)

story.append(PageBreak())

# SECTION 5: OBJECTION HANDLERS
story.append(Paragraph("Section 5: Objection Handlers", styles['SectionH']))
story.append(Paragraph("When a client pushes back on price, timeline, or scope. Stay calm, stay confident.", styles['Body']))

story.append(Paragraph('Template 21: "That\'s more than we budgeted"', styles['TemplateH']))
story += email_block(
    "Re: [PROJECT] pricing",
    "Hi [NAME],<br/><br/>Totally understand — budget matters. A couple options:<br/><br/><b>Option A:</b> We keep the full scope at $[FULL PRICE]. This gives you [full deliverables].<br/><br/><b>Option B:</b> We reduce scope to [SMALLER DELIVERABLE] at $[LOWER PRICE]. This still gives you [core value] and we can always add the rest later.<br/><br/>I'd rather adjust scope than cut corners. Which feels like a better fit for where you are right now?<br/><br/>[YOUR NAME]",
    "Never lower your rate. Lower the scope. This protects your hourly value and trains clients that your work is worth the price."
)

story.append(Paragraph('Template 22: "We got a lower quote from someone else"', styles['TemplateH']))
story += email_block(
    "Re: [PROJECT] — comparing options",
    "Hi [NAME],<br/><br/>Makes sense to compare — I'd do the same thing. A few things to consider when evaluating:<br/><br/>1. Does the other quote include [SPECIFIC THING YOU INCLUDE — e.g., SEO optimization, unlimited revisions, strategy consultation]?<br/>2. What's their turnaround time and revision process?<br/>3. Do they have experience specifically in [THEIR INDUSTRY]?<br/><br/>My pricing reflects [brief value statement — e.g., 5 years of experience in your industry, a track record of measurable results, a white-glove process that saves you management time].<br/><br/>Happy to walk through the differences if it helps. Either way, I want you to make the right choice for [COMPANY].<br/><br/>[YOUR NAME]",
    "Never trash the competition. Instead, educate the client on what to compare. The specifics will do the work."
)

story.append(PageBreak())
story.append(Paragraph('Template 23: "Can you do it faster?"', styles['TemplateH']))
story += email_block(
    "Re: [PROJECT] timeline",
    "Hi [NAME],<br/><br/>I can definitely expedite this. Here's what that looks like:<br/><br/><b>Standard timeline:</b> [X days] at $[STANDARD PRICE]<br/><b>Rush timeline:</b> [Y days] at $[RUSH PRICE — typically 50% premium]<br/><br/>The rush rate reflects the schedule reshuffling on my end. Quality stays the same — I just need to move other commitments to prioritize yours.<br/><br/>Want to go with the rush timeline?<br/><br/>[YOUR NAME]",
    "Rush fees are not a penalty — they're the price of priority. Present it that way."
)

story.append(Paragraph('Template 24: "We need to think about it"', styles['TemplateH']))
story += email_block(
    "Re: [PROJECT] proposal — no rush",
    "Hi [NAME],<br/><br/>Absolutely — take your time. A few things that might help your decision:<br/><br/>1. [Key benefit #1 that addresses their specific pain point]<br/>2. [Key benefit #2 — time or money saved]<br/>3. I have [TIMEFRAME] of availability before my calendar fills up for [MONTH]<br/><br/>If it helps, I'm happy to hop on a quick call to answer any questions from your team. Sometimes that speeds things up.<br/><br/>Let me know either way — no pressure.<br/><br/>[YOUR NAME]",
    "Create gentle urgency with availability, not artificial deadlines. Real scarcity is more believable."
)

story.append(Paragraph('Template 25: "We decided to go in a different direction"', styles['TemplateH']))
story += email_block(
    "Re: [PROJECT] — understood",
    "Hi [NAME],<br/><br/>Understood — appreciate you letting me know. No hard feelings at all.<br/><br/>If you don't mind me asking: was there something specific about the proposal that didn't fit? I'm always looking to improve, and candid feedback goes a long way.<br/><br/>Either way, I wish you and [COMPANY] all the best with the project. If things don't work out with the other option, my door's always open.<br/><br/>[YOUR NAME]",
    "Graceful losses become future wins. 20% of \"lost\" deals come back within 6 months if you handle the rejection well."
)

# CTA PAGE
story.append(PageBreak())
story.append(Spacer(1, 1*inch))
story.append(Paragraph("Want More Freelancer Tools?", styles['CTitle']))
story.append(Spacer(1, 0.2*inch))
story.append(HRFlowable(width="30%", thickness=2, color=BLUE))
story.append(Spacer(1, 0.3*inch))

upsell_data = [
    [Paragraph("<b>AI Prompts for Freelancers</b> — $24<br/>50 prompts for client intake, proposals, admin, and more.<br/>outdoorphunk.gumroad.com/l/ai-prompts-freelancers", styles['Body'])],
    [Paragraph("<b>Freelancer Invoice + Client Tracker (Notion)</b> — $39<br/>Track clients, invoices, projects, and revenue in one place.<br/>outdoorphunk.gumroad.com/l/notion-freelancer-tracker", styles['Body'])],
    [Paragraph("<b>Freelance Starter Kit Bundle</b> — $49 (save 22%)<br/>Everything above in one package.<br/>outdoorphunk.gumroad.com/l/freelance-starter-kit", styles['Body'])],
]
upsell = Table(upsell_data, colWidths=[5*inch])
upsell.setStyle(TableStyle([
    ('BACKGROUND', (0,0), (-1,-1), LIGHT),
    ('BOX', (0,0), (-1,-1), 1, BLUE),
    ('INNERGRID', (0,0), (-1,-1), 0.5, HexColor('#DEE2E6')),
    ('TOPPADDING', (0,0), (-1,-1), 10),
    ('BOTTOMPADDING', (0,0), (-1,-1), 10),
    ('LEFTPADDING', (0,0), (-1,-1), 14),
]))
story.append(upsell)

story.append(Spacer(1, 0.3*inch))
cta = Table(
    [[Paragraph("<b>Use code LAUNCH25 for 25% off any product</b><br/>Limited to first 50 buyers", styles['CTA'])]],
    colWidths=[4.5*inch]
)
cta.setStyle(TableStyle([
    ('BACKGROUND', (0,0), (-1,-1), HexColor('#FFF8E1')),
    ('BOX', (0,0), (-1,-1), 2, AMBER),
    ('TOPPADDING', (0,0), (-1,-1), 14),
    ('BOTTOMPADDING', (0,0), (-1,-1), 14),
    ('ALIGN', (0,0), (-1,-1), 'CENTER'),
]))
story.append(cta)

doc.build(story)
print(f"Created: {output_path}")
