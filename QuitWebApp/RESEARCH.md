# QuitWebApp Research Notes (Smoking + Vaping Cessation Gamification)

## Scope
This file translates medical and behavioral evidence into practical game mechanics for a quit app.

## Medical timeline evidence used for milestone design

### Reliable timeline anchors after quitting smoking
- Within minutes: heart rate drops.
- 24 hours: nicotine blood level drops to zero.
- Several days: carbon monoxide drops toward non-smoker levels.
- 1 to 12 months: cough and shortness of breath decrease.
- 1 to 2 years: heart attack risk drops sharply.
- 3 to 6 years: extra coronary heart disease risk drops by about half.
- 5 to 10 years: added risk of cancers of mouth/throat/voice box drops by half.

Source: CDC benefits timeline.

### Withdrawal intensity window
- Withdrawal is typically strongest in the first days to weeks.
- First week is high-risk for relapse.

Sources: Smokefree.gov and CDC withdrawal guidance.

### Vaping-specific evidence constraints
- Quitting vaping likely follows similar nicotine withdrawal mechanisms.
- FDA has not approved e-cigarettes as cessation medications.
- Long-term vaping health effects remain uncertain.

Source: CDC vaping and quitting guidance.

## Behavioral/gamification evidence used

### What gamification can do
- Gamification in cessation apps is associated with better motivation/self-efficacy and engagement signals.
- Effects depend on implementation quality and retention over time.

Sources: JMIR Serious Games studies and systematic reviews.

### Why frequent rewards are important early
- Contingency management (immediate rewards contingent on abstinence/behavior) improves short-term smoking outcomes in multiple RCTs and meta-analyses.
- Effects often weaken when rewards stop, so systems should shift from extrinsic rewards to identity/skill loops over time.

Sources: PubMed RCTs and meta-analyses on contingency management.

### Why day-8 drop-off happens
- Digital smoking interventions frequently show attrition/engagement decay.
- More sustained usage trajectories are linked with better quit outcomes.

Sources: JAMA Network Open 2024 engagement analysis and JMIR usage trajectory work.

## Pre-quit preparation evidence (used for new prep milestones)

### Set a near-term quit date
- Smokefree/NCI quit-planning guidance recommends setting a specific quit date and preparing before that day.

### Remove cues from environment
- CDC quit guidance recommends removing cigarettes and smoking cues (lighters, matches, ashtrays) from home, car, and work.
- NCI patient education guidance similarly recommends throwing away tobacco supplies and cue objects.

### Build social and coping support before quit day
- CDC and Smokefree recommend telling supportive people in advance and practicing distraction/coping options before the quit day.
- Smokefree specifically advises having NRT ready for quit day if planning to use it.

### Frame slips as recoverable (not total failure)
- Smokefree relapse guidance: slips are temporary setbacks and should be used to learn triggers and restart quickly.
- CDC fast facts: quitting often takes multiple attempts; relapse-sensitive design should reduce shame spirals.

## Constipation, pimples, and other "body change" claims

### Constipation after quitting: real, with moderate evidence
- Clinical cohort data reports constipation as a common short-term symptom after smoking cessation, with higher incidence in early abstinence windows.
- This supports in-app "gut shift" milestones in the first days to weeks, with recovery framing rather than alarm framing.

### Pimples/acne after quitting: mixed evidence, not a guaranteed milestone
- Evidence for acne itself is mixed and heterogeneous across populations; studies do not support a simple universal claim.
- We should not present "acne gets better/worse by day X" as a hard medical milestone.
- Better approach: mark acne-related cards as "possible/mixed evidence" and focus core milestones on stronger outcomes (cardio, respiratory, cancer-risk, nicotine withdrawal).

### Skin benefits overall: medically plausible and partially measured
- Strong dermatology literature links smoking with premature skin aging and poorer skin biology.
- Smoking cessation studies have shown measurable skin color/microcirculation improvements over weeks to months.
- So skin-improvement milestones are valid if phrased as likely trends, not guaranteed cosmetic outcomes.

## Design implications for this app

1. Dense milestones in first 30 days.
- Daily through day 14.
- Every 2 days through day 30.
- Then taper frequency (every 3-7 days) while adding multi-track goals.

2. Multi-track progression to avoid "nothing happened today".
- Health (research-backed milestones)
- Money (savings thresholds)
- Nicotine freedom (time clean)
- Resilience (cravings resisted, streak skills)

3. Immediate reward + delayed meaning.
- Immediate: XP, streak protection, mystery drops.
- Delayed: identity title upgrades, health unlock cards, future-self trust score.

4. Ethical guardrails.
- Encourage support resources and evidence-based cessation methods.
- Avoid predatory mechanics (no punishment spirals, no pay-to-progress).
- Keep medical claims conservative and source-backed.

5. Planned-quit mode should still be rewarding.
- Add pre-quit milestones at tighter intervals (for example T-14d, T-10d, T-7d, T-5d, T-3d, T-2d, T-1d, T-1h).
- Focus tasks on proven preparation behaviors:
  - Commit quit date
  - Build support circle
  - Trigger map
  - Environment cue cleanup (including ashtray/lighter removal)
  - NRT readiness and craving-action plan

6. Slip handling should preserve identity momentum.
- Avoid framing one cigarette as total run failure.
- Use graded penalties and weekly trend review.
- Offer optional milestone revert (user-controlled) and quick restart prompts.

7. Add a transparent "Body" milestone track.
- Include constipation and skin milestones with evidence labels:
  - `moderate` for constipation and skin-circulation recovery
  - `mixed` for acne/pimple outcomes
- Keep copy explicit that individuals vary.

## Sources
- CDC: Benefits of Quitting Smoking
  - https://www.cdc.gov/tobacco/about/benefits-of-quitting.html
- CDC: How to Quit Smoking
  - https://www.cdc.gov/tobacco/about/how-to-quit.html
- CDC: Smoking Cessation Fast Facts
  - https://www.cdc.gov/tobacco/php/data-statistics/smoking-cessation/index.html
- CDC: Vaping and Quitting
  - https://www.cdc.gov/tobacco/e-cigarettes/quitting.html
- CDC Tips Campaign: Tips for Quitting (environment cue removal)
  - https://www.cdc.gov/tobacco/campaign/tips/quit-smoking/tips-for-quitting/index.html
- Smokefree.gov: Managing Withdrawal
  - https://smokefree.gov/challenges-when-quitting/managing-withdrawal
- Smokefree.gov: Prepare to Quit
  - https://smokefree.gov/quit-smoking/getting-started/prepare-to-quit
- Smokefree.gov: Get Back on Track After a Setback
  - https://smokefree.nci.nih.gov/challenges-when-quitting/stick-with-it/get-back-on-track
- CDC: 7 Common Withdrawal Symptoms
  - https://www.cdc.gov/tobacco/campaign/tips/quit-smoking/7-common-withdrawal-symptoms/index.html
- NCI: Clearing the Air (cue-removal actions)
  - https://www.cancer.gov/publications/patient-education/clearing-the-air-pdf
- FDA: Every Try Counts (process framing)
  - https://www.fda.gov/media/153192/download
- Smoking cessation and constipation cohort (nicotine withdrawal GI effects)
  - https://pubmed.ncbi.nlm.nih.gov/14616182/
- Smoking cessation and skin color recovery (4-12 week prospective follow-up)
  - https://pubmed.ncbi.nlm.nih.gov/23113589/
- Smoking and skin aging review
  - https://pubmed.ncbi.nlm.nih.gov/17951030/
- Acne-smoking relationship meta-analysis (heterogeneous/mixed)
  - https://pmc.ncbi.nlm.nih.gov/articles/PMC8367059/
- JMIR Serious Games (gamification + motivation/self-efficacy)
  - https://pubmed.ncbi.nlm.nih.gov/33904824/
- JMIR Serious Games longitudinal gamification study
  - https://pubmed.ncbi.nlm.nih.gov/27777216/
- Systematic review/meta-analysis (gamification & smoking cessation)
  - https://pubmed.ncbi.nlm.nih.gov/40575736/
- JAMA Network Open (engagement trajectories in mobile cessation)
  - https://pubmed.ncbi.nlm.nih.gov/38922618/
- JMIR app-use trajectories and quit outcomes
  - https://pubmed.ncbi.nlm.nih.gov/35831180/
- Contingency management meta-analysis (short-term efficacy)
  - https://pubmed.ncbi.nlm.nih.gov/33048571/
- Contingency management RCT examples
  - https://pubmed.ncbi.nlm.nih.gov/24793364/
  - https://pubmed.ncbi.nlm.nih.gov/30869980/
