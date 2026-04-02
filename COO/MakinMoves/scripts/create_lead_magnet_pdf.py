from reportlab.lib.pagesizes import letter
from reportlab.lib.units import inch
from reportlab.lib.colors import HexColor
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, HRFlowable
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.enums import TA_CENTER, TA_LEFT

output_path = '/sessions/nifty-adoring-turing/mnt/MakinMoves/products/lead_magnet/5_Free_AI_Prompts_for_Freelancers.pdf'

import os
os.makedirs(os.path.dirname(output_path), exist_ok=True)

doc = SimpleDocTemplate(output_path, pagesize=letter,
    topMargin=0.75*inch, bottomMargin=0.75*inch,
    leftMargin=0.85*inch, rightMargin=0.85*inch)

styles = getSampleStyleSheet()

# Custom styles
styles.add(ParagraphStyle('CoverTitle', parent=styles['Title'],
    fontSize=28, leading=34, textColor=HexColor('#1B2A4A'),
    spaceAfter=12, alignment=TA_CENTER))

styles.add(ParagraphStyle('CoverSub', parent=styles['Normal'],
    fontSize=14, leading=18, textColor=HexColor('#555555'),
    spaceAfter=6, alignment=TA_CENTER))

styles.add(ParagraphStyle('PromptTitle', parent=styles['Heading1'],
    fontSize=18, leading=22, textColor=HexColor('#2D5AA0'),
    spaceBefore=16, spaceAfter=8))

styles.add(ParagraphStyle('PromptNum', parent=styles['Normal'],
    fontSize=11, leading=14, textColor=HexColor('#FFFFFF'),
    alignment=TA_CENTER))

styles.add(ParagraphStyle('Body', parent=styles['Normal'],
    fontSize=11, leading=16, textColor=HexColor('#333333'),
    spaceAfter=8))

styles.add(ParagraphStyle('PromptBox', parent=styles['Normal'],
    fontSize=10.5, leading=15, textColor=HexColor('#1B2A4A'),
    spaceAfter=6, leftIndent=12, rightIndent=12))

styles.add(ParagraphStyle('Tip', parent=styles['Normal'],
    fontSize=10, leading=14, textColor=HexColor('#0D652D'),
    spaceAfter=8, leftIndent=12))

styles.add(ParagraphStyle('CTA', parent=styles['Normal'],
    fontSize=14, leading=18, textColor=HexColor('#2D5AA0'),
    alignment=TA_CENTER, spaceBefore=12, spaceAfter=8))

styles.add(ParagraphStyle('CTABig', parent=styles['Title'],
    fontSize=22, leading=28, textColor=HexColor('#1B2A4A'),
    alignment=TA_CENTER, spaceBefore=20, spaceAfter=12))

styles.add(ParagraphStyle('Footer', parent=styles['Normal'],
    fontSize=9, leading=12, textColor=HexColor('#999999'),
    alignment=TA_CENTER))

BLUE = HexColor('#2D5AA0')
LIGHT_BLUE = HexColor('#E8F0FE')
DARK = HexColor('#1B2A4A')
GREEN = HexColor('#0D652D')

story = []

# ===== PAGE 1: COVER =====
story.append(Spacer(1, 1.5*inch))
story.append(Paragraph("5 AI Prompts That Save<br/>Freelancers 1 Hour Every Day", styles['CoverTitle']))
story.append(Spacer(1, 0.3*inch))
story.append(HRFlowable(width="40%", thickness=2, color=BLUE))
story.append(Spacer(1, 0.3*inch))
story.append(Paragraph("Copy. Paste. Get back to billable work.", styles['CoverSub']))
story.append(Spacer(1, 0.2*inch))
story.append(Paragraph("These 5 prompts are pulled from our full library of 50 prompts<br/>built specifically for freelancers managing multiple clients.", styles['CoverSub']))
story.append(Spacer(1, 0.5*inch))

cover_table = Table([
    [Paragraph("<b>What's inside:</b>", styles['Body'])],
    [Paragraph("1. Client Intake Questionnaire Generator", styles['Body'])],
    [Paragraph("2. Proposal Writer (Plug-and-Play)", styles['Body'])],
    [Paragraph("3. Scope of Work Clarifier", styles['Body'])],
    [Paragraph("4. Professional Follow-Up Email Writer", styles['Body'])],
    [Paragraph("5. Rate Negotiation Helper", styles['Body'])],
], colWidths=[4.5*inch])
cover_table.setStyle(TableStyle([
    ('BACKGROUND', (0,0), (-1,0), LIGHT_BLUE),
    ('BACKGROUND', (0,1), (-1,-1), HexColor('#F8F9FA')),
    ('BOX', (0,0), (-1,-1), 1, BLUE),
    ('INNERGRID', (0,0), (-1,-1), 0.5, HexColor('#DEE2E6')),
    ('TOPPADDING', (0,0), (-1,-1), 6),
    ('BOTTOMPADDING', (0,0), (-1,-1), 6),
    ('LEFTPADDING', (0,0), (-1,-1), 12),
]))
story.append(cover_table)

story.append(Spacer(1, 0.4*inch))
story.append(Paragraph("outdoorphunk.gumroad.com", styles['Footer']))
story.append(PageBreak())

# ===== PROMPT PAGES =====
prompts = [
    {
        "num": "1",
        "title": "Client Intake Questionnaire Generator",
        "when": "A new client reaches out and you need to gather project details fast without forgetting key questions.",
        "prompt": """I'm a freelance [YOUR SPECIALTY, e.g., copywriter/designer/developer]. A potential client just contacted me about [BRIEF DESCRIPTION OF THEIR REQUEST].

Generate a professional client intake questionnaire I can send them. Include questions about:
- Their business (industry, size, target audience)
- Project scope (specific deliverables, timeline, budget range)
- Brand voice and preferences (if applicable)
- Decision-making process (who approves, how many revision rounds)
- Success metrics (how they'll measure if this project worked)

Format it as a numbered list I can paste into an email. Keep the tone professional but approachable. Add a brief intro paragraph I can use.""",
        "tip": "Customize the specialty field once and save your version. You'll reuse this for every new prospect.",
        "saves": "30 minutes per new client"
    },
    {
        "num": "2",
        "title": "Proposal Writer (Plug-and-Play)",
        "when": "You need to send a professional proposal but don't want to spend an hour writing one from scratch.",
        "prompt": """Write a freelance project proposal for the following:

Client: [CLIENT NAME]
Project: [BRIEF DESCRIPTION]
My specialty: [YOUR SPECIALTY]
Deliverables: [LIST WHAT YOU'LL DELIVER]
Timeline: [ESTIMATED TIMELINE]
Price: [YOUR PRICE]

Structure the proposal with these sections:
1. Executive summary (2-3 sentences showing I understand their problem)
2. Proposed solution (what I'll deliver and why this approach works)
3. Scope of work (specific deliverables with descriptions)
4. Timeline (milestones with dates)
5. Investment (price with payment terms: 50% upfront, 50% on delivery)
6. What's included / What's not included
7. Next steps (clear CTA to move forward)

Tone: confident, professional, not salesy. Show expertise through specificity, not buzzwords.""",
        "tip": "Feed in notes from your discovery call. The more specific the input, the less editing you'll need.",
        "saves": "45 minutes per proposal"
    },
    {
        "num": "3",
        "title": "Scope of Work Clarifier",
        "when": "A client's request is vague or you can feel scope creep coming. Use this before it becomes a problem.",
        "prompt": """I'm a freelancer and my client just sent me this request:

\"[PASTE THE CLIENT'S MESSAGE OR REQUEST HERE]\"

Help me:
1. Identify what's clearly defined vs. what's ambiguous
2. List 5-7 specific clarifying questions I should ask before starting work
3. Draft a professional response that:
   - Confirms what I understand so far
   - Asks the clarifying questions naturally (not as a rigid list)
   - Sets expectations about timeline and process
   - Gently establishes boundaries (what's included vs. what would be additional)

Keep my tone helpful and collaborative, not defensive. I want the client to feel supported, not interrogated.""",
        "tip": "Use this BEFORE you start working, not after. Preventing scope creep is 10x easier than fixing it.",
        "saves": "Hours of rework + awkward conversations"
    },
    {
        "num": "4",
        "title": "Professional Follow-Up Email Writer",
        "when": "A prospect went quiet, a client hasn't responded, or you need to nudge without being annoying.",
        "prompt": """Write a follow-up email for this situation:

Who: [CLIENT/PROSPECT NAME]
Context: [WHAT HAPPENED — e.g., "sent proposal 5 days ago, no response" or "delivered draft, waiting on feedback for 3 days"]
My goal: [WHAT I WANT — e.g., "get them to respond" or "move to next phase"]
Tone: [professional / casual / warm but firm]

Requirements:
- Subject line that gets opened (not "Following up" or "Checking in")
- Keep it under 100 words
- Include a specific, easy-to-answer question (not "thoughts?")
- Add a soft deadline or next step
- Don't guilt-trip or sound desperate
- Sound like a human, not a template""",
        "tip": "The key is the specific question. \"Does Tuesday work for a 15-min call?\" beats \"Let me know your thoughts\" every time.",
        "saves": "20 minutes per follow-up (plus the mental energy of drafting awkward emails)"
    },
    {
        "num": "5",
        "title": "Rate Negotiation Helper",
        "when": "A client pushes back on your price, asks for a discount, or you need to justify your rates.",
        "prompt": """A client just said: \"[PASTE THEIR EXACT OBJECTION — e.g., 'That's more than we budgeted' or 'Can you do it for less?' or 'We got a lower quote from someone else']\"

My rate: [YOUR RATE]
Project: [BRIEF DESCRIPTION]
My experience level: [YEARS + RELEVANT CREDENTIALS]

Help me respond. I want to:
1. Acknowledge their concern without apologizing for my rate
2. Reframe the value (what they get, not what they pay)
3. Offer ONE alternative that protects my rate (e.g., reduce scope, adjust timeline, offer payment plan) — not a discount
4. Include a confident closing that moves the conversation forward

Keep it under 150 words. I want to sound experienced and calm, not defensive or desperate. Never undercut my own value.""",
        "tip": "Never lower your rate — lower the scope. \"I can do X for that budget\" protects your hourly value while still closing the deal.",
        "saves": "The difference between a $1,500 project and a $3,000 one"
    }
]

for p in prompts:
    # Prompt number badge
    badge = Table(
        [[Paragraph(f"<b>PROMPT {p['num']}</b>", styles['PromptNum'])]],
        colWidths=[1.5*inch], rowHeights=[0.35*inch]
    )
    badge.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), BLUE),
        ('ALIGN', (0,0), (-1,-1), 'CENTER'),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
        ('ROUNDEDCORNERS', [4,4,4,4]),
    ]))
    story.append(badge)
    story.append(Paragraph(p['title'], styles['PromptTitle']))

    story.append(Paragraph(f"<b>When to use:</b> {p['when']}", styles['Body']))
    story.append(Paragraph(f"<b>Time saved:</b> {p['saves']}", styles['Body']))
    story.append(Spacer(1, 0.15*inch))

    # Prompt box
    prompt_content = p['prompt'].replace('\n', '<br/>')
    prompt_table = Table(
        [[Paragraph(f"<b>THE PROMPT:</b><br/><br/>{prompt_content}", styles['PromptBox'])]],
        colWidths=[5.8*inch]
    )
    prompt_table.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), HexColor('#F0F4F8')),
        ('BOX', (0,0), (-1,-1), 1, HexColor('#CBD5E1')),
        ('TOPPADDING', (0,0), (-1,-1), 12),
        ('BOTTOMPADDING', (0,0), (-1,-1), 12),
        ('LEFTPADDING', (0,0), (-1,-1), 14),
        ('RIGHTPADDING', (0,0), (-1,-1), 14),
    ]))
    story.append(prompt_table)

    story.append(Spacer(1, 0.1*inch))
    story.append(Paragraph(f"<b>Pro tip:</b> {p['tip']}", styles['Tip']))

    if p['num'] != '5':
        story.append(PageBreak())

# ===== CTA PAGE =====
story.append(PageBreak())
story.append(Spacer(1, 1*inch))
story.append(Paragraph("Like These? There Are 45 More.", styles['CTABig']))
story.append(Spacer(1, 0.2*inch))
story.append(HRFlowable(width="30%", thickness=2, color=BLUE))
story.append(Spacer(1, 0.3*inch))

story.append(Paragraph("The full <b>AI Prompts for Freelancers</b> library includes<br/>50 prompts across 10 categories:", styles['CTA']))

categories = [
    "Client Intake & Onboarding", "Proposal & Pitch Writing",
    "Scope & Contract Clarity", "Email & Communication",
    "Rate & Negotiation", "Project Management",
    "Content & Copywriting", "Invoice & Payment",
    "Client Retention & Upsell", "Personal Productivity"
]

cat_data = [[Paragraph(f"<b>{i+1}.</b> {c}", styles['Body'])] for i, c in enumerate(categories)]
cat_table = Table(cat_data, colWidths=[4*inch])
cat_table.setStyle(TableStyle([
    ('BACKGROUND', (0,0), (-1,-1), LIGHT_BLUE),
    ('BOX', (0,0), (-1,-1), 1, BLUE),
    ('TOPPADDING', (0,0), (-1,-1), 4),
    ('BOTTOMPADDING', (0,0), (-1,-1), 4),
    ('LEFTPADDING', (0,0), (-1,-1), 16),
]))
story.append(cat_table)

story.append(Spacer(1, 0.4*inch))

cta_box = Table(
    [[Paragraph("<b>Get the full 50-prompt library for just $24</b><br/><br/>outdoorphunk.gumroad.com/l/ai-prompts-freelancers<br/><br/>Use code <b>LAUNCH25</b> for 25% off (limited to first 50 buyers)", styles['CTA'])]],
    colWidths=[5*inch]
)
cta_box.setStyle(TableStyle([
    ('BACKGROUND', (0,0), (-1,-1), HexColor('#FFF8E1')),
    ('BOX', (0,0), (-1,-1), 2, HexColor('#F9A825')),
    ('TOPPADDING', (0,0), (-1,-1), 16),
    ('BOTTOMPADDING', (0,0), (-1,-1), 16),
    ('LEFTPADDING', (0,0), (-1,-1), 20),
    ('RIGHTPADDING', (0,0), (-1,-1), 20),
    ('ALIGN', (0,0), (-1,-1), 'CENTER'),
]))
story.append(cta_box)

story.append(Spacer(1, 0.5*inch))
story.append(Paragraph("Want everything? The <b>Freelance Starter Kit Bundle</b> ($49) includes<br/>the full prompt library + the Notion Invoice & Client Tracker.<br/><br/>outdoorphunk.gumroad.com/l/freelance-starter-kit", styles['CTA']))

doc.build(story)
print(f"Created: {output_path}")
