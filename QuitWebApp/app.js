const STORAGE_KEY = "quitQuestStateV1";

const DEFAULT_STATE = {
  quitDate: new Date(Date.now() - 6 * 60 * 60 * 1000).toISOString(),
  streakStartAt: new Date(Date.now() - 6 * 60 * 60 * 1000).toISOString(),
  productType: "cigarettes",
  currency: "USD",
  dailyConsumption: 15,
  costPerPack: 12,
  packSize: 20,
  cigaretteStrength: "medium",
  nrtMode: "log",
  nrtSelectedProduct: "gum",
  nrtConfigs: {
    gum: { mgPerUnit: 2, unitsPerPack: 20, packCost: 0 },
    lozenge: { mgPerUnit: 2, unitsPerPack: 20, packCost: 0 },
    spray: { mgPerUnit: 1, unitsPerPack: 100, packCost: 0 },
    patch24: { mgPerUnit: 21, unitsPerPack: 7, packCost: 0 },
    patch16: { mgPerUnit: 15, unitsPerPack: 7, packCost: 0 }
  },
  customPatchProfiles: [],
  selectedCustomPatchId: "",
  nrtLogs: [],
  nicotinePlan: {
    startDate: "",
    phases: [
      { mgPerDay: 0, days: 0 },
      { mgPerDay: 0, days: 0 },
      { mgPerDay: 0, days: 0 },
      { mgPerDay: 0, days: 0 }
    ]
  },
  activeXP: 0,
  cravingsResisted: 0,
  streakShields: 1,
  shieldFragments: 0,
  slips: 0,
  selectedTrigger: "",
  lastChestDate: "",
  titleTokens: 0,
  dailyRecords: {},
  smokeLogByDay: {},
  lastWeeklyReviewDate: new Date().toISOString().slice(0, 10),
  dailyNicotineHistory: {},
  milestoneStatus: {},
  milestoneClaimedAt: {},
  milestoneClaimedXP: {},
  legacyNRTMigrationDone: false
};

const QUEST_BANK = [
  { id: "breath", title: "Mindful Moment", subtitle: "2-minute breathing reset", xp: 25 },
  { id: "logger", title: "Craving Logger", subtitle: "Log one trigger + one win", xp: 40 },
  { id: "money", title: "Money Counter", subtitle: "Check savings and reward goal", xp: 20 },
  { id: "health", title: "Health Check", subtitle: "Read your next health card", xp: 30 },
  { id: "future", title: "Letter Writer", subtitle: "Write 3 lines to future self", xp: 45 },
  { id: "water", title: "Hydration Hero", subtitle: "8 glasses today", xp: 35 },
  { id: "walk", title: "Movement Master", subtitle: "10-minute walk", xp: 45 },
  { id: "gratitude", title: "Gratitude Practice", subtitle: "3 things you are proud of", xp: 30 }
];

const HEALTH_MILESTONES = [
  { id: "h20m", type: "health", hours: 20 / 60, title: "Heart Whisperer", desc: "Heart rate starts dropping toward normal.", xp: 50 },
  { id: "h8h", type: "health", hours: 8, title: "Oxygen Rising", desc: "Carbon monoxide starts dropping.", xp: 90 },
  { id: "h24h", type: "health", hours: 24, title: "Nicotine Clear", desc: "Nicotine blood level reaches near zero.", xp: 120 },
  { id: "h48h", type: "health", hours: 48, title: "Taste Awakening", desc: "Taste and smell keep recovering.", xp: 150 },
  { id: "h72h", type: "health", hours: 72, title: "Peak Survivor", desc: "You pushed through the toughest withdrawal zone.", xp: 200 },
  { id: "h168h", type: "health", hours: 168, title: "Week One Rewire", desc: "The first week is a key relapse-risk window. You cleared it.", xp: 240 },
  { id: "h336h", type: "health", hours: 336, title: "Week Two Wind", desc: "Breathing comfort usually starts improving.", xp: 300 },
  { id: "h720h", type: "health", hours: 720, title: "Month One Reset", desc: "Lung recovery signs build over the first month.", xp: 500 },
  { id: "h2160h", type: "health", hours: 2160, title: "Month Three Heart Guard", desc: "Cardiovascular and lung gains continue.", xp: 900 },
  { id: "h4380h", type: "health", hours: 4380, title: "Half-Year Breath Master", desc: "Sustained respiratory and circulation gains.", xp: 1300 },
  { id: "h8760h", type: "health", hours: 8760, title: "Year One Phoenix", desc: "Heart disease risk keeps dropping meaningfully.", xp: 2200 }
];

const SYMPTOM_BODY_MILESTONES = [
  {
    id: "sb-24h-gut-shift",
    type: "symptom",
    hours: 24,
    title: "Gut Shift Window",
    desc: "Some people notice constipation after quitting; nicotine withdrawal can reduce gut motility.",
    xp: 80,
    evidence: "moderate"
  },
  {
    id: "sb-336h-gut-easing",
    type: "symptom",
    hours: 336,
    title: "Gut Rhythm Recovery",
    desc: "Constipation often peaks around week 2 in cohort data, then trends toward recovery.",
    xp: 140,
    evidence: "moderate"
  },
  {
    id: "sb-672h-skin-rebound",
    type: "symptom",
    hours: 672,
    title: "Skin Oxygen Rebound",
    desc: "Clinical follow-up studies report measurable skin color and microcirculation gains after cessation.",
    xp: 220,
    evidence: "moderate"
  },
  {
    id: "sb-2016h-complexion",
    type: "symptom",
    hours: 2016,
    title: "Complexion Stabilizing",
    desc: "Pimple/acne response is mixed across studies. Some get short flares; long-term skin aging risk trends improve.",
    xp: 320,
    evidence: "mixed"
  }
];

const PRE_QUIT_MILESTONE_TEMPLATE = [
  {
    id: "prep-lock-date",
    type: "prep",
    prepOrder: 1,
    hoursUntilQuitMax: 24 * 3650,
    title: "Quit Date Locked",
    desc: "Set your quit date and make a clear commitment statement.",
    xp: 35
  },
  {
    id: "prep-support-circle",
    type: "prep",
    prepOrder: 2,
    hoursUntilQuitMax: 24 * 14,
    title: "Support Circle",
    desc: "Tell at least one person your quit date and ask for support.",
    xp: 45
  },
  {
    id: "prep-trigger-map",
    type: "prep",
    prepOrder: 3,
    hoursUntilQuitMax: 24 * 10,
    title: "Trigger Map",
    desc: "List your top triggers and pair each with one coping action.",
    xp: 55
  },
  {
    id: "prep-environment-sweep",
    type: "prep",
    prepOrder: 4,
    hoursUntilQuitMax: 24 * 7,
    title: "Environment Sweep",
    desc: "Remove cigarettes/vapes from home, car, and work areas.",
    xp: 70
  },
  {
    id: "prep-throw-ashtray",
    type: "prep",
    prepOrder: 5,
    hoursUntilQuitMax: 24 * 5,
    title: "Throw Ashtray Ritual",
    desc: "Throw away ashtrays, lighters, and backup stash triggers.",
    xp: 80
  },
  {
    id: "prep-nrt-ready",
    type: "prep",
    prepOrder: 6,
    hoursUntilQuitMax: 24 * 3,
    title: "NRT Ready",
    desc: "Configure your NRT products so support is ready on demand.",
    xp: 90
  },
  {
    id: "prep-craving-plan",
    type: "prep",
    prepOrder: 7,
    hoursUntilQuitMax: 24 * 2,
    title: "Craving Plan",
    desc: "Practice one rescue cycle and choose your first-line action.",
    xp: 105
  },
  {
    id: "prep-night-before",
    type: "prep",
    prepOrder: 8,
    hoursUntilQuitMax: 24,
    title: "Night-Before Reset",
    desc: "Prepare tomorrow morning routine without nicotine cues.",
    xp: 125
  },
  {
    id: "prep-launch-hour",
    type: "prep",
    prepOrder: 9,
    hoursUntilQuitMax: 1,
    title: "Launch Hour",
    desc: "Quit window is here. Start your run and protect the first 24 hours.",
    xp: 160
  }
];

const ABSTINENCE_NICOTINE_MILESTONES = [
  { id: "n12h", type: "nicotine", hours: 12, title: "Nicotine Gap", desc: "12h clean from nicotine use.", xp: 70 },
  { id: "n18h", type: "nicotine", hours: 18, title: "Urge Splitter", desc: "18h clean. Urges come in waves, not forever.", xp: 80 },
  { id: "n24h", type: "nicotine", hours: 24, title: "Day One Lock", desc: "First full day nicotine-free.", xp: 100 },
  { id: "n36h", type: "nicotine", hours: 36, title: "Storm Rider", desc: "36h clean. Keep surfing urges.", xp: 115 },
  { id: "n48h", type: "nicotine", hours: 48, title: "Two-Day Anchor", desc: "2 full days of nicotine freedom.", xp: 130 },
  { id: "n72h", type: "nicotine", hours: 72, title: "Three-Day Crown", desc: "Many withdrawal symptoms peak around this window.", xp: 170 },
  { id: "n96h", type: "nicotine", hours: 96, title: "Craving Decoder", desc: "4 days clean. Pattern awareness grows.", xp: 185 },
  { id: "n120h", type: "nicotine", hours: 120, title: "Five-Day Flow", desc: "5 days clean. Momentum is real.", xp: 210 },
  { id: "n168h", type: "nicotine", hours: 168, title: "Week One Keeper", desc: "1 week nicotine-free.", xp: 260 }
];

const NRT_PRODUCTS = ["gum", "lozenge", "spray", "patch24", "patch16", "patchCustom"];
const NRT_PLAN_PHASE_COUNT = 4;
const NRT_PRODUCT_META = {
  gum: { label: "Gum", defaultMg: 2, defaultPackUnits: 20, defaultPackCost: 0 },
  lozenge: { label: "Lozenge", defaultMg: 2, defaultPackUnits: 20, defaultPackCost: 0 },
  spray: { label: "Spray", defaultMg: 1, defaultPackUnits: 100, defaultPackCost: 0 },
  patch24: { label: "Patch 24h", defaultMg: 21, defaultPackUnits: 7, defaultPackCost: 0 },
  patch16: { label: "Patch 16h", defaultMg: 15, defaultPackUnits: 7, defaultPackCost: 0 },
  patchCustom: { label: "Custom Patch", defaultMg: 14, defaultPackUnits: 7, defaultPackCost: 0 }
};

const LEGACY_NRT_MAPPINGS = [
  { product: "gum", countKey: "gumCount", mgKey: "gumMg", unitsKey: "gumPackUnits", costKey: "gumPackCost" },
  { product: "lozenge", countKey: "lozengeCount", mgKey: "lozengeMg", unitsKey: "lozengePackUnits", costKey: "lozengePackCost" },
  { product: "spray", countKey: "sprayCount", mgKey: "sprayMg", unitsKey: "sprayPackUnits", costKey: "sprayPackCost" },
  { product: "patch24", countKey: "patch24Count", mgKey: "patch24Mg", unitsKey: "patch24PackUnits", costKey: "patch24PackCost" },
  { product: "patch16", countKey: "patch16Count", mgKey: "patch16Mg", unitsKey: "patch16PackUnits", costKey: "patch16PackCost" }
];

const NRT_EFFECTIVE_FACTOR = {
  gum: 0.65,
  lozenge: 0.65,
  spray: 0.9,
  patch24: 0.75,
  patch16: 0.75,
  patchCustom: 0.75
};

const CIGARETTE_STRENGTH_NICOTINE_MG = {
  mild: 0.8,
  medium: 1.1,
  strong: 1.4
};

let state = loadState();
let activeFilter = "all";
let rescueInterval = null;
let rescueRemaining = 90;
let rescueRunning = false;
let milestoneQueue = [];
let queueMode = false;
let activeMilestone = null;
let levelUpContinuation = null;
let levelUpSequence = [];
let levelUpSequenceIndex = 0;

const el = {
  levelRing: document.getElementById("levelRing"),
  levelValue: document.getElementById("levelValue"),
  timeClean: document.getElementById("timeClean"),
  xpText: document.getElementById("xpText"),
  trustScore: document.getElementById("trustScore"),
  moneySaved: document.getElementById("moneySaved"),
  nrtSpent: document.getElementById("nrtSpent"),
  netSavings: document.getElementById("netSavings"),
  nicotineToday: document.getElementById("nicotineToday"),
  nicotineReduction: document.getElementById("nicotineReduction"),
  cigsAvoided: document.getElementById("cigsAvoided"),
  cravingsResisted: document.getElementById("cravingsResisted"),
  shieldCount: document.getElementById("shieldCount"),
  nextUnlockEta: document.getElementById("nextUnlockEta"),
  nextUnlockTitle: document.getElementById("nextUnlockTitle"),
  nextUnlockDesc: document.getElementById("nextUnlockDesc"),
  questList: document.getElementById("questList"),
  questCount: document.getElementById("questCount"),
  milestoneList: document.getElementById("milestoneList"),
  rescueRing: document.getElementById("rescueRing"),
  rescueTime: document.getElementById("rescueTime"),
  rescueFeedback: document.getElementById("rescueFeedback"),
  selectedTrigger: document.getElementById("selectedTrigger"),
  profileSheet: document.getElementById("profileSheet"),
  nrtSheet: document.getElementById("nrtSheet"),
  quitDateInput: document.getElementById("quitDateInput"),
  productTypeInput: document.getElementById("productTypeInput"),
  currencyInput: document.getElementById("currencyInput"),
  dailyInput: document.getElementById("dailyInput"),
  costInput: document.getElementById("costInput"),
  packSizeInput: document.getElementById("packSizeInput"),
  cigaretteStrengthInput: document.getElementById("cigaretteStrengthInput"),
  baselineEstimateText: document.getElementById("baselineEstimateText"),
  resetProgress: document.getElementById("resetProgress"),
  customPatchNameInput: document.getElementById("customPatchNameInput"),
  nrtHistoryDateTimeInput: document.getElementById("nrtHistoryDateTimeInput"),
  nrtHistoryUseNowBtn: document.getElementById("nrtHistoryUseNowBtn"),
  nrtHistoryTypeSelect: document.getElementById("nrtHistoryTypeSelect"),
  nrtHistoryQuantityInput: document.getElementById("nrtHistoryQuantityInput"),
  nrtHistoryLogBtn: document.getElementById("nrtHistoryLogBtn"),
  undoLastNRTLog: document.getElementById("undoLastNRTLog"),
  quickLogPatch24: document.getElementById("quickLogPatch24"),
  quickLogPatch16: document.getElementById("quickLogPatch16"),
  quickPatchInfo: document.getElementById("quickPatchInfo"),
  quickApplyCustomPatchList: document.getElementById("quickApplyCustomPatchList"),
  customPatchHoursInput: document.getElementById("customPatchHoursInput"),
  customPatchMgInput: document.getElementById("customPatchMgInput"),
  customPatchBoxUnitsInput: document.getElementById("customPatchBoxUnitsInput"),
  customPatchBoxCostInput: document.getElementById("customPatchBoxCostInput"),
  saveCustomPatch: document.getElementById("saveCustomPatch"),
  customPatchList: document.getElementById("customPatchList"),
  nrtConfigNote: document.getElementById("nrtConfigNote"),
  nrtLogList: document.getElementById("nrtLogList"),
  nrtQuickSummary: document.getElementById("nrtQuickSummary"),
  planStartDateInput: document.getElementById("planStartDateInput"),
  planPhase1Mg: document.getElementById("planPhase1Mg"),
  planPhase1Days: document.getElementById("planPhase1Days"),
  planPhase2Mg: document.getElementById("planPhase2Mg"),
  planPhase2Days: document.getElementById("planPhase2Days"),
  planPhase3Mg: document.getElementById("planPhase3Mg"),
  planPhase3Days: document.getElementById("planPhase3Days"),
  planPhase4Mg: document.getElementById("planPhase4Mg"),
  planPhase4Days: document.getElementById("planPhase4Days"),
  saveNicotinePlan: document.getElementById("saveNicotinePlan"),
  applyExamplePlan: document.getElementById("applyExamplePlan"),
  nicotineTrendChart: document.getElementById("nicotineTrendChart"),
  nicotineTrendSummary: document.getElementById("nicotineTrendSummary"),
  milestoneModal: document.getElementById("milestoneModal"),
  milestoneModalTitle: document.getElementById("milestoneModalTitle"),
  milestoneModalDesc: document.getElementById("milestoneModalDesc"),
  milestoneModalMeta: document.getElementById("milestoneModalMeta"),
  milestoneUnlockBtn: document.getElementById("milestoneUnlockBtn"),
  milestoneUnlockAllBtn: document.getElementById("milestoneUnlockAllBtn"),
  milestoneSkipBtn: document.getElementById("milestoneSkipBtn"),
  milestoneSkipAllBtn: document.getElementById("milestoneSkipAllBtn"),
  levelUpModal: document.getElementById("levelUpModal"),
  levelUpTitle: document.getElementById("levelUpTitle"),
  levelUpMilestone: document.getElementById("levelUpMilestone"),
  levelUpText: document.getElementById("levelUpText"),
  levelUpProgressText: document.getElementById("levelUpProgressText"),
  levelUpProgressFill: document.getElementById("levelUpProgressFill"),
  levelUpContinueBtn: document.getElementById("levelUpContinueBtn"),
  levelUpSkipBtn: document.getElementById("levelUpSkipBtn")
};

wireTabs();
wireProfileSheet();
wireNRTSheet();
wireCravingActions();
wireQuestActions();
wireFilters();
wireNRTConfigActions();
wireMilestoneActions();

seedDailyQuests();
hydrateProfileForm();
hydrateNRTControls();
hydrateNicotinePlanForm();
const startupWeeklySummaries = runWeeklySmokingReviewIfDue();
renderAll();
queueMissedMilestones();
if (startupWeeklySummaries.length) {
  window.alert(startupWeeklySummaries.join("\n"));
  showFeedback(startupWeeklySummaries[startupWeeklySummaries.length - 1]);
}
window.addEventListener("resize", renderNicotineTrendChart);

setInterval(() => {
  renderAll();
  queueMissedMilestones();
}, 1000);

function loadState() {
  const defaultState = JSON.parse(JSON.stringify(DEFAULT_STATE));
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return defaultState;
    const parsed = JSON.parse(raw);
    const merged = { ...defaultState, ...parsed };
    merged.nrtConfigs = normalizeNRTConfigs(parsed);
    merged.customPatchProfiles = normalizeCustomPatchProfiles(parsed?.customPatchProfiles);
    merged.selectedCustomPatchId = normalizeSelectedCustomPatchId(parsed?.selectedCustomPatchId, merged.customPatchProfiles);
    merged.nrtLogs = normalizeNRTLogs(parsed?.nrtLogs);
    merged.nicotinePlan = normalizeNicotinePlan(parsed?.nicotinePlan);
    merged.cigaretteStrength = normalizeCigaretteStrength(parsed?.cigaretteStrength);
    merged.smokeLogByDay = normalizeSmokeLogByDay(parsed?.smokeLogByDay);
    merged.lastWeeklyReviewDate = isDayKey(parsed?.lastWeeklyReviewDate) ? parsed.lastWeeklyReviewDate : getTodayKey();
    merged.milestoneClaimedAt = normalizeMilestoneClaimedAt(parsed?.milestoneClaimedAt);
    merged.milestoneClaimedXP = normalizeMilestoneClaimedXP(parsed?.milestoneClaimedXP);
    merged.nrtMode = merged.nrtMode === "config" ? "config" : "log";
    merged.nrtSelectedProduct = NRT_PRODUCTS.includes(merged.nrtSelectedProduct) ? merged.nrtSelectedProduct : "gum";
    merged.legacyNRTMigrationDone = Boolean(parsed?.legacyNRTMigrationDone);
    migrateLegacyNRTCountsToLogs(parsed, merged);
    stripLegacyNRTFields(merged);
    return merged;
  } catch {
    return defaultState;
  }
}

function saveState() {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
}

function normalizeNRTConfigs(parsed) {
  const incoming = parsed?.nrtConfigs || {};
  const legacyKeys = {
    gum: { mg: "gumMg", units: "gumPackUnits", cost: "gumPackCost" },
    lozenge: { mg: "lozengeMg", units: "lozengePackUnits", cost: "lozengePackCost" },
    spray: { mg: "sprayMg", units: "sprayPackUnits", cost: "sprayPackCost" },
    patch24: { mg: "patch24Mg", units: "patch24PackUnits", cost: "patch24PackCost" },
    patch16: { mg: "patch16Mg", units: "patch16PackUnits", cost: "patch16PackCost" }
  };

  const num = (value, fallback, min = 0) => {
    const candidate = Number(value);
    if (Number.isFinite(candidate)) return Math.max(min, candidate);
    const fallbackCandidate = Number(fallback);
    if (Number.isFinite(fallbackCandidate)) return Math.max(min, fallbackCandidate);
    return min;
  };

  const configs = {};
  NRT_PRODUCTS.forEach((product) => {
    const meta = NRT_PRODUCT_META[product];
    const raw = incoming[product] || {};
    const legacy = legacyKeys[product];
    const legacyMg = legacy ? parsed?.[legacy.mg] : undefined;
    const legacyUnits = legacy ? parsed?.[legacy.units] : undefined;
    const legacyCost = legacy ? parsed?.[legacy.cost] : undefined;
    configs[product] = {
      mgPerUnit: num(raw.mgPerUnit, legacyMg ?? meta.defaultMg, 0.1),
      unitsPerPack: Math.max(1, Math.round(num(raw.unitsPerPack, legacyUnits ?? meta.defaultPackUnits, 1))),
      packCost: num(raw.packCost, legacyCost ?? meta.defaultPackCost, 0)
    };
  });

  return configs;
}

function normalizeCustomPatchProfiles(rawProfiles) {
  if (!Array.isArray(rawProfiles)) return [];

  return rawProfiles
    .map((profile, idx) => {
      const hours = Math.max(1, Math.round(Number(profile?.hours || 0)));
      const mgPerUnit = Math.max(0.1, Number(profile?.mgPerUnit || 0));
      const unitsPerBox = Math.max(1, Math.round(Number(profile?.unitsPerBox || 0)));
      const boxCost = Math.max(0, Number(profile?.boxCost || 0));
      if (!Number.isFinite(hours) || !Number.isFinite(mgPerUnit) || !Number.isFinite(unitsPerBox) || !Number.isFinite(boxCost)) return null;

      const id = profile?.id ? String(profile.id) : `patch-custom-${idx}`;
      const label = profile?.label ? String(profile.label) : `${hours}h • ${mgPerUnit}mg`;
      return { id, label, hours, mgPerUnit, unitsPerBox, boxCost };
    })
    .filter(Boolean);
}

function normalizeSelectedCustomPatchId(rawId, profiles) {
  const id = rawId ? String(rawId) : "";
  if (!id) return profiles[0]?.id || "";
  return profiles.some((p) => p.id === id) ? id : (profiles[0]?.id || "");
}

function normalizeNRTLogs(rawLogs) {
  if (!Array.isArray(rawLogs)) return [];

  return rawLogs
    .map((log, idx) => {
      const product = String(log?.product || "");
      if (!NRT_PRODUCTS.includes(product)) return null;
      const timestamp = new Date(log?.timestamp);
      if (!Number.isFinite(timestamp.getTime())) return null;

      let quantity = Math.max(1, Math.round(Number(log?.quantity || 1)));
      let nicotineMg = Math.max(0, Number(log?.nicotineMg || 0));
      let cost = Math.max(0, Number(log?.cost || 0));

      // Old builds could accidentally persist multi-patch logs (e.g., x20).
      // Patch usage is one-at-a-time, so normalize to 1 unit while keeping per-unit values.
      if (isPatchProduct(product) && quantity > 1) {
        const perUnitNicotine = nicotineMg > 0 ? nicotineMg / quantity : Number(NRT_PRODUCT_META[product]?.defaultMg || 0);
        const perUnitCost = cost > 0 ? cost / quantity : 0;
        quantity = 1;
        nicotineMg = Number(Math.max(0, perUnitNicotine).toFixed(2));
        cost = Number(Math.max(0, perUnitCost).toFixed(2));
      }

      const id = log?.id ? String(log.id) : `log-${timestamp.getTime()}-${idx}`;
      const patchProfileId = log?.patchProfileId ? String(log.patchProfileId) : "";
      const patchHours = Math.max(0, Math.round(Number(log?.patchHours || 0)));
      const patchLabel = log?.patchLabel ? String(log.patchLabel) : "";

      return {
        id,
        timestamp: timestamp.toISOString(),
        product,
        quantity,
        nicotineMg,
        cost,
        patchProfileId,
        patchHours,
        patchLabel
      };
    })
    .filter(Boolean);
}

function normalizeNicotinePlan(rawPlan) {
  const today = getTodayKey();
  const startDate = isDayKey(rawPlan?.startDate) ? rawPlan.startDate : today;
  const rawPhases = Array.isArray(rawPlan?.phases) ? rawPlan.phases : [];
  const phases = [];

  for (let i = 0; i < NRT_PLAN_PHASE_COUNT; i += 1) {
    const phase = rawPhases[i] || {};
    const mgPerDay = Math.max(0, Number(phase.mgPerDay || 0));
    const days = Math.max(0, Math.round(Number(phase.days || 0)));
    phases.push({ mgPerDay, days });
  }

  return { startDate, phases };
}

function normalizeCigaretteStrength(value) {
  const key = String(value || "").toLowerCase();
  if (key === "mild" || key === "medium" || key === "strong") return key;
  return "medium";
}

function normalizeSmokeLogByDay(rawLog) {
  if (!rawLog || typeof rawLog !== "object") return {};
  const clean = {};
  Object.entries(rawLog).forEach(([dayKey, value]) => {
    if (!isDayKey(dayKey)) return;
    const count = Math.max(0, Math.round(Number(value) || 0));
    if (count > 0) clean[dayKey] = count;
  });
  return clean;
}

function normalizeMilestoneClaimedAt(rawValue) {
  if (!rawValue || typeof rawValue !== "object") return {};
  const clean = {};
  Object.entries(rawValue).forEach(([id, timestamp]) => {
    const date = new Date(timestamp);
    if (!Number.isFinite(date.getTime())) return;
    clean[id] = date.toISOString();
  });
  return clean;
}

function normalizeMilestoneClaimedXP(rawValue) {
  if (!rawValue || typeof rawValue !== "object") return {};
  const clean = {};
  Object.entries(rawValue).forEach(([id, xp]) => {
    clean[id] = Math.max(0, Number(xp) || 0);
  });
  return clean;
}

function stripLegacyNRTFields(target) {
  if (!target || typeof target !== "object") return;
  LEGACY_NRT_MAPPINGS.forEach((mapping) => {
    delete target[mapping.countKey];
    delete target[mapping.mgKey];
    delete target[mapping.unitsKey];
    delete target[mapping.costKey];
  });
}

function migrateLegacyNRTCountsToLogs(parsed, merged) {
  if (!parsed) return;
  if (merged.legacyNRTMigrationDone === true || parsed?.legacyNRTMigrationDone === true) return;
  if (merged.nrtLogs.length > 0) {
    merged.legacyNRTMigrationDone = true;
    return;
  }

  const nowISO = new Date().toISOString();
  LEGACY_NRT_MAPPINGS.forEach((mapping, idx) => {
    const quantity = Math.max(0, Number(parsed[mapping.countKey] || 0));
    if (quantity <= 0) return;

    const config = merged.nrtConfigs[mapping.product];
    const mgPerUnit = Math.max(0.1, Number(parsed[mapping.mgKey] || config.mgPerUnit || 0.1));
    const unitsPerPack = Math.max(1, Math.round(Number(parsed[mapping.unitsKey] || config.unitsPerPack || 1)));
    const packCost = Math.max(0, Number(parsed[mapping.costKey] || config.packCost || 0));

    merged.nrtConfigs[mapping.product] = { mgPerUnit, unitsPerPack, packCost };

    const unitCost = packCost / unitsPerPack;
    merged.nrtLogs.push({
      id: `migrated-${mapping.product}-${Date.now()}-${idx}`,
      timestamp: nowISO,
      product: mapping.product,
      quantity,
      nicotineMg: Number((quantity * mgPerUnit).toFixed(2)),
      cost: Number((quantity * unitCost).toFixed(2))
    });
  });

  merged.legacyNRTMigrationDone = true;
}

function getNow() {
  return Date.now();
}

function getQuitDateMs() {
  const quitMs = new Date(state.quitDate).getTime();
  if (Number.isFinite(quitMs)) return quitMs;
  const now = getNow();
  state.quitDate = new Date(now).toISOString();
  return now;
}

function isPlanningMode() {
  return getQuitDateMs() > getNow();
}

function getHoursUntilQuit() {
  const remainingMs = getQuitDateMs() - getNow();
  return Math.max(0, remainingMs / (1000 * 60 * 60));
}

function getElapsedMs() {
  const diff = getNow() - getQuitDateMs();
  return Math.max(0, diff);
}

function getElapsedHours() {
  return getElapsedMs() / (1000 * 60 * 60);
}

function getElapsedDays() {
  return getElapsedHours() / 24;
}

function getCigsAvoided() {
  return getElapsedDays() * Number(state.dailyConsumption || 0);
}

function getMoneySaved() {
  const perUnit = Number(state.costPerPack || 0) / Math.max(1, Number(state.packSize || 1));
  return getCigsAvoided() * perUnit;
}

function getNRTConfig(product) {
  const key = NRT_PRODUCTS.includes(product) ? product : "gum";
  if (!state.nrtConfigs[key]) {
    const meta = NRT_PRODUCT_META[key];
    state.nrtConfigs[key] = {
      mgPerUnit: meta.defaultMg,
      unitsPerPack: meta.defaultPackUnits,
      packCost: meta.defaultPackCost
    };
  }
  return state.nrtConfigs[key];
}

function getCustomPatchProfiles() {
  if (!Array.isArray(state.customPatchProfiles)) state.customPatchProfiles = [];
  state.customPatchProfiles = normalizeCustomPatchProfiles(state.customPatchProfiles);
  return state.customPatchProfiles;
}

function getCustomPatchProfileById(profileId) {
  const id = String(profileId || "");
  if (!id) return null;
  return getCustomPatchProfiles().find((profile) => profile.id === id) || null;
}

function getCustomPatchUnitCost(profile) {
  if (!profile) return 0;
  return Math.max(0, Number(profile.boxCost || 0)) / Math.max(1, Number(profile.unitsPerBox || 1));
}

function getCustomPatchLabel(profile) {
  if (!profile) return "Custom Patch";
  const name = String(profile.label || "Custom Patch").trim();
  return `${name} (${profile.hours}h, ${Number(profile.mgPerUnit).toFixed(1)} mg)`;
}

function getLogDayKey(log) {
  if (!log?.timestamp) return "";
  return String(log.timestamp).slice(0, 10);
}

function getNRTLogTotalsForDay(dayKey = getTodayKey()) {
  let nicotine = 0;
  let cost = 0;

  (state.nrtLogs || []).forEach((log) => {
    if (getLogDayKey(log) !== dayKey) return;
    nicotine += Math.max(0, Number(log.nicotineMg || 0));
    cost += Math.max(0, Number(log.cost || 0));
  });

  return { nicotine, cost };
}

function getEffectiveNicotineForLog(log) {
  const raw = Math.max(0, Number(log?.nicotineMg || 0));
  const product = NRT_PRODUCTS.includes(log?.product) ? log.product : "gum";
  const factor = Number(NRT_EFFECTIVE_FACTOR[product] || 1);
  return raw * factor;
}

function getNRTEffectiveNicotineForDay(dayKey = getTodayKey()) {
  let nicotineEquivalent = 0;
  (state.nrtLogs || []).forEach((log) => {
    if (getLogDayKey(log) !== dayKey) return;
    nicotineEquivalent += getEffectiveNicotineForLog(log);
  });
  return Math.max(0, nicotineEquivalent);
}

function getNRTDailyCost(dayKey = getTodayKey()) {
  return getNRTLogTotalsForDay(dayKey).cost;
}

function getNRTSpent() {
  return (state.nrtLogs || []).reduce((sum, log) => sum + Math.max(0, Number(log.cost || 0)), 0);
}

function estimateBaselineNicotineMg() {
  const usage = Number(state.dailyConsumption || 0);
  const strength = normalizeCigaretteStrength(state.cigaretteStrength);
  const mgPerCig = Number(CIGARETTE_STRENGTH_NICOTINE_MG[strength] || CIGARETTE_STRENGTH_NICOTINE_MG.medium);

  if (state.productType === "cigarettes") return Math.max(0, usage * mgPerCig);
  if (state.productType === "vape") return Math.max(0, usage * 1.0);
  return Math.max(0, usage * ((mgPerCig + 1.0) / 2));
}

function getBaselineNicotineMg() {
  return Math.max(0, estimateBaselineNicotineMg());
}

function getCurrentNicotineMg(dayKey = getTodayKey()) {
  return Math.max(0, getNRTLogTotalsForDay(dayKey).nicotine);
}

function getCurrentNicotineEquivalentMg(dayKey = getTodayKey()) {
  return Math.max(0, getNRTEffectiveNicotineForDay(dayKey));
}

function getNicotineReductionPct() {
  const baseline = getBaselineNicotineMg();
  if (baseline <= 0) return 0;
  const current = getCurrentNicotineEquivalentMg();
  return Math.max(0, Math.min(100, ((baseline - current) / baseline) * 100));
}

function updateDailyNicotineHistory() {
  const logTotals = {};
  (state.nrtLogs || []).forEach((log) => {
    const day = getLogDayKey(log);
    if (!day) return;
    logTotals[day] = (Number(logTotals[day]) || 0) + getEffectiveNicotineForLog(log);
  });
  const merged = { ...(state.dailyNicotineHistory || {}), ...logTotals };
  const today = getTodayKey();
  merged[today] = getCurrentNicotineEquivalentMg(today);
  state.dailyNicotineHistory = merged;
}

function getRecentNicotineTrendMgPerDay() {
  const entries = Object.entries(state.dailyNicotineHistory || {})
    .sort(([a], [b]) => a.localeCompare(b))
    .slice(-7);

  if (entries.length < 2) return 0;
  const first = Number(entries[0][1]) || 0;
  const last = Number(entries[entries.length - 1][1]) || 0;
  const days = Math.max(1, entries.length - 1);
  return (first - last) / days;
}

function getTotalXP() {
  return Number(state.activeXP || 0);
}

function getLevelData(totalXP) {
  let level = 1;
  let base = 0;
  let cost = 62;

  while (level < 100) {
    cost = Math.round(55 + level * 7);
    if (totalXP >= base + cost) {
      base += cost;
      level += 1;
    } else {
      break;
    }
  }

  const progress = Math.max(0, Math.min(1, (totalXP - base) / cost));
  const xpToNext = Math.max(0, cost - (totalXP - base));

  return { level, progress, xpToNext };
}

function getTrustScore() {
  const streakDays = getStreakDays();
  const score = 45 + Math.min(35, streakDays * 1.1) + Math.min(20, state.cravingsResisted * 0.38) - state.slips * 6;
  return Math.max(0, Math.min(100, Math.round(score)));
}

function getStreakDays() {
  const diff = getNow() - new Date(state.streakStartAt).getTime();
  return Math.max(0, Math.floor(diff / (1000 * 60 * 60 * 24)));
}

function formatMoney(n) {
  const currency = state.currency || "USD";
  try {
    return new Intl.NumberFormat(undefined, { style: "currency", currency, maximumFractionDigits: 2 }).format(n);
  } catch {
    return `${currency} ${Number(n).toFixed(2)}`;
  }
}

function formatDuration(ms) {
  const s = Math.floor(ms / 1000);
  const days = Math.floor(s / 86400);
  const hours = Math.floor((s % 86400) / 3600);
  const mins = Math.floor((s % 3600) / 60);
  const secs = s % 60;

  if (days > 0) return `${days}d ${pad(hours)}:${pad(mins)}:${pad(secs)}`;
  return `${pad(hours)}:${pad(mins)}:${pad(secs)}`;
}

function formatShortHoursWindow(hoursValue) {
  const hours = Math.max(0, Number(hoursValue) || 0);
  if (hours < 1) return `${Math.max(1, Math.round(hours * 60))}m`;
  if (hours < 24) return `${Math.round(hours)}h`;
  const days = hours / 24;
  if (Math.abs(days - Math.round(days)) < 0.01) return `${Math.round(days)}d`;
  return `${days.toFixed(1)}d`;
}

function pad(v) {
  return String(v).padStart(2, "0");
}

function getTodayKey() {
  return new Date().toISOString().slice(0, 10);
}

function isDayKey(value) {
  if (typeof value !== "string" || !/^\d{4}-\d{2}-\d{2}$/.test(value)) return false;
  const [y, m, d] = value.split("-").map(Number);
  const date = new Date(Date.UTC(y, m - 1, d));
  return Number.isFinite(date.getTime());
}

function parseDayKey(dayKey) {
  if (!isDayKey(dayKey)) return null;
  const [y, m, d] = dayKey.split("-").map(Number);
  return new Date(Date.UTC(y, m - 1, d));
}

function addDaysToDayKey(dayKey, days) {
  const date = parseDayKey(dayKey);
  if (!date) return getTodayKey();
  date.setUTCDate(date.getUTCDate() + Number(days || 0));
  return date.toISOString().slice(0, 10);
}

function dayDiff(fromDayKey, toDayKey) {
  const from = parseDayKey(fromDayKey);
  const to = parseDayKey(toDayKey);
  if (!from || !to) return 0;
  const msPerDay = 24 * 60 * 60 * 1000;
  return Math.floor((to.getTime() - from.getTime()) / msPerDay);
}

function seededPickThree(items, seedText) {
  let seed = 0;
  for (let i = 0; i < seedText.length; i += 1) {
    seed = (seed * 31 + seedText.charCodeAt(i)) % 2147483647;
  }

  const copy = [...items];
  for (let i = copy.length - 1; i > 0; i -= 1) {
    seed = (seed * 48271) % 2147483647;
    const j = seed % (i + 1);
    [copy[i], copy[j]] = [copy[j], copy[i]];
  }

  return copy.slice(0, 3);
}

function seedDailyQuests() {
  const day = getTodayKey();
  if (state.dailyRecords[day]) return;

  const picks = seededPickThree(QUEST_BANK, day);
  state.dailyRecords[day] = {
    ids: picks.map((q) => q.id),
    completed: {}
  };
  saveState();
}

function getTodayQuests() {
  const day = getTodayKey();
  const record = state.dailyRecords[day];
  if (!record) return [];

  return record.ids.map((id) => QUEST_BANK.find((q) => q.id === id)).filter(Boolean);
}

function getQuestCompletedCount() {
  const day = getTodayKey();
  const record = state.dailyRecords[day];
  if (!record) return 0;
  return Object.keys(record.completed).length;
}

function completeQuest(id) {
  const day = getTodayKey();
  const record = state.dailyRecords[day];
  if (!record || record.completed[id]) return;

  record.completed[id] = true;
  const quest = QUEST_BANK.find((q) => q.id === id);
  if (quest) {
    state.activeXP += quest.xp;
    maybeOpenMysteryChest(0.2);
    showFeedback(`Quest complete: ${quest.title} (+${quest.xp} XP)`);
  }

  saveState();
  renderAll();
}

function getMomentumMilestones() {
  const items = [];
  for (let d = 1; d <= 14; d += 1) {
    items.push({
      id: `m-d-${d}`,
      type: "momentum",
      hours: d * 24,
      title: `Day ${d} Momentum`,
      desc: "You stacked another day. Keep the chain alive.",
      xp: 55 + d * 6
    });
  }

  for (let d = 16; d <= 30; d += 2) {
    items.push({
      id: `m-d-${d}`,
      type: "momentum",
      hours: d * 24,
      title: `Day ${d} Expansion`,
      desc: "Post-week-one zone: consistency is the game.",
      xp: 120 + d * 3
    });
  }

  for (let d = 33; d <= 60; d += 3) {
    items.push({
      id: `m-d-${d}`,
      type: "momentum",
      hours: d * 24,
      title: `Day ${d} Identity Build`,
      desc: "Your non-smoker identity is getting stronger.",
      xp: 170 + d * 3
    });
  }

  return items;
}

function getMoneyMilestones() {
  const marks = [5, 10, 15, 20, 30, 40, 50, 75, 100, 150, 200, 300, 500, 750, 1000];
  return marks.map((amount) => ({
    id: `money-${amount}`,
    type: "money",
    amount,
    title: `${formatMoney(amount)} Saved`,
    desc: "Redirect this to a reward you actually care about.",
    xp: Math.round(30 + amount * 0.6)
  }));
}

function getResilienceMilestones() {
  const marks = [3, 5, 8, 12, 20, 30, 45, 60, 80, 100, 140, 180];
  return marks.map((count) => ({
    id: `res-${count}`,
    type: "resilience",
    count,
    title: `${count} Cravings Resisted`,
    desc: "Every resisted urge rewires your default response.",
    xp: Math.round(40 + count * 4)
  }));
}

function getMilestoneStatus(id) {
  return state.milestoneStatus?.[id] || "";
}

function setMilestoneStatus(id, status) {
  state.milestoneStatus[id] = status;
}

function isMilestoneClaimed(id) {
  return getMilestoneStatus(id) === "claimed";
}

function isMilestoneSkipped(id) {
  return getMilestoneStatus(id) === "skipped";
}

function getMilestoneUnlockXP(milestone) {
  if (!milestone) return 0;
  return Number(milestone.xp || 0);
}

function getMilestoneClaimedXP(id) {
  const saved = Number(state.milestoneClaimedXP?.[id]);
  if (Number.isFinite(saved) && saved >= 0) return saved;
  const milestone = getAllMilestones().find((m) => m.id === id);
  return milestone ? Number(milestone.xp || 0) : 0;
}

function clearMilestoneClaimMeta(id) {
  if (state.milestoneClaimedAt?.[id] != null) delete state.milestoneClaimedAt[id];
  if (state.milestoneClaimedXP?.[id] != null) delete state.milestoneClaimedXP[id];
}

function revertLatestClaimedMilestone() {
  const claimedIds = Object.entries(state.milestoneStatus || {})
    .filter(([, status]) => status === "claimed")
    .map(([id]) => id);
  if (!claimedIds.length) return null;

  const ranked = claimedIds.map((id) => {
    const milestone = getAllMilestones().find((m) => m.id === id);
    const claimedAt = new Date(state.milestoneClaimedAt?.[id] || "");
    const claimedAtMs = Number.isFinite(claimedAt.getTime()) ? claimedAt.getTime() : 0;
    const fallbackSort = milestone ? getMilestoneSortValue(milestone) : 0;
    return { id, milestone, claimedAtMs, fallbackSort };
  });

  ranked.sort((a, b) => {
    if (b.claimedAtMs !== a.claimedAtMs) return b.claimedAtMs - a.claimedAtMs;
    return b.fallbackSort - a.fallbackSort;
  });

  const target = ranked[0];
  if (!target?.milestone) return null;

  const reclaimXP = Math.max(0, getMilestoneClaimedXP(target.id));
  state.activeXP = Math.max(0, Number(state.activeXP || 0) - reclaimXP);
  setMilestoneStatus(target.id, "");
  clearMilestoneClaimMeta(target.id);

  return { milestone: target.milestone, removedXP: reclaimXP };
}

function getNicotineMilestones() {
  const current = getCurrentNicotineEquivalentMg();
  const baseline = Math.max(1, getBaselineNicotineMg());

  if (current <= 0.05) {
    return ABSTINENCE_NICOTINE_MILESTONES;
  }

  const reductionTargets = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
  return reductionTargets.map((pct, idx) => {
    const targetMg = Number((baseline * (1 - pct / 100)).toFixed(1));
    return {
      id: `ntaper-${pct}`,
      type: "nicotine",
      reductionPct: pct,
      targetNicotineMg: targetMg,
      title: `${pct}% Nicotine Reduction`,
      desc: pct < 100
        ? `Taper NRT to ${targetMg} mg/day or lower.`
        : "Reach zero nicotine from NRT.",
      xp: 90 + idx * 35
    };
  });
}

function getPrepMilestones() {
  if (!isPlanningMode()) return [];
  return PRE_QUIT_MILESTONE_TEMPLATE.map((item) => ({ ...item }));
}

function getAllMilestones() {
  return [
    ...getPrepMilestones(),
    ...HEALTH_MILESTONES,
    ...SYMPTOM_BODY_MILESTONES,
    ...getNicotineMilestones(),
    ...getMomentumMilestones(),
    ...getMoneyMilestones(),
    ...getResilienceMilestones()
  ];
}

function isMilestoneUnlocked(m) {
  const hours = getElapsedHours();
  const money = getMoneySaved();
  const resisted = state.cravingsResisted;
  const currentNicotine = getCurrentNicotineEquivalentMg();
  const hoursUntilQuit = getHoursUntilQuit();

  if (typeof m.hoursUntilQuitMax === "number") {
    if (!isPlanningMode()) return false;
    return hoursUntilQuit <= m.hoursUntilQuitMax;
  }
  if (typeof m.hours === "number") return hours >= m.hours;
  if (typeof m.targetNicotineMg === "number") return currentNicotine <= m.targetNicotineMg;
  if (typeof m.amount === "number") return money >= m.amount;
  if (typeof m.count === "number") return resisted >= m.count;
  return false;
}

function milestoneEtaLabel(m) {
  const hours = getElapsedHours();
  const money = getMoneySaved();
  const currentNicotine = getCurrentNicotineEquivalentMg();
  const hoursUntilQuit = getHoursUntilQuit();

  if (typeof m.hoursUntilQuitMax === "number") {
    if (!isPlanningMode()) return "Planning mode";
    const rem = hoursUntilQuit - m.hoursUntilQuitMax;
    if (rem <= 0) return "Ready";
    if (rem < 1) return `in ${Math.ceil(rem * 60)}m`;
    if (rem < 24) return `in ${Math.ceil(rem)}h`;
    return `in ${Math.ceil(rem / 24)}d`;
  }

  if (typeof m.hours === "number") {
    let rem = m.hours - hours;
    if (isPlanningMode()) rem += hoursUntilQuit;
    if (rem <= 0) return "Unlocked";
    if (rem < 1) return `${Math.ceil(rem * 60)}m`;
    if (rem < 24) return `${Math.ceil(rem)}h`;
    return `${Math.ceil(rem / 24)}d`;
  }

  if (typeof m.amount === "number") {
    const remMoney = m.amount - money;
    if (remMoney <= 0) return "Unlocked";
    const hourlyRate = Math.max(0.05, (state.dailyConsumption * (state.costPerPack / Math.max(1, state.packSize))) / 24);
    let remHours = remMoney / hourlyRate;
    if (isPlanningMode()) remHours += hoursUntilQuit;
    if (remHours < 24) return `${Math.ceil(remHours)}h`;
    return `${Math.ceil(remHours / 24)}d`;
  }

  if (typeof m.targetNicotineMg === "number") {
    const diff = currentNicotine - m.targetNicotineMg;
    if (diff <= 0) return "Unlocked";
    const trend = getRecentNicotineTrendMgPerDay();
    if (trend > 0.01) {
      const days = diff / trend;
      return days < 1 ? `${Math.ceil(days * 24)}h` : `${Math.ceil(days)}d`;
    }
    return `-${diff.toFixed(1)} mg/day`;
  }

  if (typeof m.count === "number") {
    const rem = m.count - state.cravingsResisted;
    if (rem <= 0) return "Unlocked";
    return `~${rem} wins`;
  }

  return "Soon";
}

function getNextMilestone() {
  const allMilestones = getAllMilestones();
  const ready = allMilestones
    .filter((m) => isMilestoneUnlocked(m) && !isMilestoneClaimed(m.id) && !isMilestoneSkipped(m.id))
    .sort((a, b) => getMilestoneSortValue(a) - getMilestoneSortValue(b));

  if (ready.length) return ready[0];

  const all = allMilestones.filter((m) => !isMilestoneUnlocked(m));
  if (!all.length) return null;

  const hours = getElapsedHours();
  const money = getMoneySaved();
  const currentNicotine = getCurrentNicotineEquivalentMg();
  const nicotineTrend = Math.max(0.01, getRecentNicotineTrendMgPerDay());
  const hoursUntilQuit = getHoursUntilQuit();

  const scored = all.map((m) => {
    let score = 999999;
    if (typeof m.hoursUntilQuitMax === "number") {
      score = Math.max(0, hoursUntilQuit - m.hoursUntilQuitMax);
    }
    if (typeof m.hours === "number") {
      score = Math.max(0, m.hours - hours);
      if (isPlanningMode()) score += hoursUntilQuit;
    }
    if (typeof m.amount === "number") {
      const hourlyRate = Math.max(0.05, (state.dailyConsumption * (state.costPerPack / Math.max(1, state.packSize))) / 24);
      score = Math.max(0, (m.amount - money) / hourlyRate);
      if (isPlanningMode()) score += hoursUntilQuit;
    }
    if (typeof m.targetNicotineMg === "number") {
      score = Math.max(0, (currentNicotine - m.targetNicotineMg) / nicotineTrend) * 24;
    }
    if (typeof m.count === "number") score = Math.max(0, (m.count - state.cravingsResisted) * 10);
    return { ...m, _score: score };
  });

  scored.sort((a, b) => a._score - b._score);
  return scored[0];
}

function awardXP(amount, reason) {
  state.activeXP += amount;
  showFeedback(`${reason} (+${amount} XP)`);
  saveState();
  renderAll();
}

function maybeOpenMysteryChest(probability = 0.35) {
  const today = getTodayKey();
  if (state.lastChestDate === today) return;
  if (Math.random() > probability) return;

  state.lastChestDate = today;
  const roll = Math.random();

  if (roll < 0.6) {
    const xp = 20 + Math.floor(Math.random() * 21);
    state.activeXP += xp;
    showFeedback(`Mystery drop: +${xp} XP`);
  } else if (roll < 0.85) {
    state.shieldFragments += 1;
    if (state.shieldFragments >= 3) {
      state.shieldFragments -= 3;
      state.streakShields += 1;
      showFeedback("Mystery drop: full shield forged");
    } else {
      showFeedback(`Mystery drop: shield fragment ${state.shieldFragments}/3`);
    }
  } else if (roll < 0.95) {
    state.streakShields += 1;
    showFeedback("Mystery drop: full streak shield");
  } else {
    state.titleTokens += 1;
    showFeedback("Mystery drop: rare title token");
  }
}

function logResistedCraving() {
  state.cravingsResisted += 1;
  const bonus = 20 + Math.min(30, state.cravingsResisted % 6 === 0 ? 20 : 10);
  awardXP(bonus, "Craving resisted");
  maybeOpenMysteryChest(0.35);
  saveState();
}

function recordSmokeForToday(count = 1) {
  const day = getTodayKey();
  const safeCount = Math.max(1, Math.round(Number(count) || 1));
  state.smokeLogByDay[day] = Math.max(0, Number(state.smokeLogByDay[day] || 0)) + safeCount;
}

function getWeeklySmokeWindow(reviewAnchorDay) {
  const windowStart = addDaysToDayKey(reviewAnchorDay, 1);
  const windowEnd = addDaysToDayKey(reviewAnchorDay, 7);
  let smokedDays = 0;
  let smokedCount = 0;

  for (let i = 1; i <= 7; i += 1) {
    const dayKey = addDaysToDayKey(reviewAnchorDay, i);
    const dayCount = Math.max(0, Number(state.smokeLogByDay?.[dayKey] || 0));
    if (dayCount >= 1) smokedDays += 1;
    smokedCount += dayCount;
  }

  return { windowStart, windowEnd, smokedDays, smokedCount };
}

function applyWeeklySmokingReview(window) {
  const { windowStart, windowEnd, smokedDays, smokedCount } = window;
  const periodLabel = `${windowStart} to ${windowEnd}`;
  let summary = "";

  if (smokedDays === 0) {
    const bonusXP = 25;
    state.activeXP += bonusXP;
    summary = `Weekly check (${periodLabel}): no smoking logged for 7 days. +${bonusXP} XP bonus.`;
    return summary;
  }

  if (smokedDays === 7) {
    const nowISO = new Date().toISOString();
    const xpPenalty = Math.min(Number(state.activeXP || 0), Math.max(80, Math.round(Number(state.activeXP || 0) * 0.35)));
    state.activeXP = Math.max(0, Number(state.activeXP || 0) - xpPenalty);
    state.quitDate = nowISO;
    state.streakStartAt = nowISO;
    summary = `Weekly check (${periodLabel}): smoking logged every day (7/7). New run started and ${xpPenalty} XP reduced.`;
    return summary;
  }

  if (smokedDays <= 3) {
    const xpPenalty = Math.min(Number(state.activeXP || 0), Math.max(15, Math.round(Number(state.activeXP || 0) * 0.06)));
    state.activeXP = Math.max(0, Number(state.activeXP || 0) - xpPenalty);
    summary = `Weekly check (${periodLabel}): smoked on ${smokedDays}/7 days (${smokedCount} total). Minor reset: -${xpPenalty} XP.`;
    return summary;
  }

  const xpPenalty = Math.min(Number(state.activeXP || 0), Math.max(45, Math.round(Number(state.activeXP || 0) * 0.15)));
  state.activeXP = Math.max(0, Number(state.activeXP || 0) - xpPenalty);
  summary = `Weekly check (${periodLabel}): smoked on ${smokedDays}/7 days (${smokedCount} total). Moderate reset: -${xpPenalty} XP.`;
  return summary;
}

function runWeeklySmokingReviewIfDue() {
  if (!isDayKey(state.lastWeeklyReviewDate)) {
    state.lastWeeklyReviewDate = getTodayKey();
    saveState();
    return [];
  }

  const summaries = [];
  let anchor = state.lastWeeklyReviewDate;
  const today = getTodayKey();

  while (dayDiff(anchor, today) >= 7) {
    const window = getWeeklySmokeWindow(anchor);
    summaries.push(applyWeeklySmokingReview(window));
    anchor = addDaysToDayKey(anchor, 7);
    state.lastWeeklyReviewDate = anchor;
  }

  if (summaries.length) {
    saveState();
  }
  return summaries;
}

function logSlip() {
  state.slips += 1;
  recordSmokeForToday(1);

  let summary = "Slip logged for today.";
  if (state.streakShields > 0) {
    state.streakShields -= 1;
    summary += " Shield used, so no immediate hard reset.";
  } else {
    const xpPenalty = Math.min(Number(state.activeXP || 0), 12);
    state.activeXP = Math.max(0, Number(state.activeXP || 0) - xpPenalty);
    summary += ` Minor penalty: -${xpPenalty} XP.`;
  }

  const wantsRevert = window.confirm("Do you want to revert your most recently unlocked milestone?");
  if (wantsRevert) {
    const reverted = revertLatestClaimedMilestone();
    if (reverted) {
      summary += ` Reverted milestone "${reverted.milestone.title}" (-${reverted.removedXP} XP).`;
    } else {
      summary += " No claimed milestone available to revert.";
    }
  }

  const weeklySummaries = runWeeklySmokingReviewIfDue();
  if (weeklySummaries.length) {
    window.alert(weeklySummaries.join("\n"));
    summary += ` ${weeklySummaries[weeklySummaries.length - 1]}`;
  }

  saveState();
  renderAll();
  showFeedback(summary);
}

function wireTabs() {
  document.querySelectorAll(".nav-item").forEach((btn) => {
    btn.addEventListener("click", () => {
      const tab = btn.dataset.tab;
      document.querySelectorAll(".nav-item").forEach((n) => n.classList.remove("active"));
      btn.classList.add("active");

      document.querySelectorAll(".tab-pane").forEach((pane) => {
        pane.classList.toggle("active", pane.id === tab);
      });
    });
  });
}

function wireProfileSheet() {
  document.getElementById("openProfile").addEventListener("click", openProfileSheet);
  document.getElementById("closeProfile").addEventListener("click", closeProfileSheet);
  document.getElementById("closeProfileBackdrop").addEventListener("click", closeProfileSheet);
  document.getElementById("saveProfile").addEventListener("click", saveProfileForm);
  if (el.resetProgress) el.resetProgress.addEventListener("click", resetProgressFlow);
  if (el.dailyInput) el.dailyInput.addEventListener("input", renderBaselineEstimatePreview);
  if (el.productTypeInput) el.productTypeInput.addEventListener("change", renderBaselineEstimatePreview);
  if (el.cigaretteStrengthInput) el.cigaretteStrengthInput.addEventListener("change", renderBaselineEstimatePreview);
}

function openProfileSheet() {
  el.profileSheet.classList.remove("hidden");
  el.profileSheet.setAttribute("aria-hidden", "false");
  renderBaselineEstimatePreview();
}

function closeProfileSheet() {
  el.profileSheet.classList.add("hidden");
  el.profileSheet.setAttribute("aria-hidden", "true");
}

function wireNRTSheet() {
  const openBtn = document.getElementById("openNRTSheet");
  const closeBtn = document.getElementById("closeNRT");
  const closeBackdrop = document.getElementById("closeNRTBackdrop");

  if (openBtn) openBtn.addEventListener("click", openNRTSheet);
  if (closeBtn) closeBtn.addEventListener("click", closeNRTSheet);
  if (closeBackdrop) closeBackdrop.addEventListener("click", closeNRTSheet);
}

function openNRTSheet() {
  if (!el.nrtSheet) return;
  el.nrtSheet.classList.remove("hidden");
  el.nrtSheet.setAttribute("aria-hidden", "false");
}

function closeNRTSheet() {
  if (!el.nrtSheet) return;
  el.nrtSheet.classList.add("hidden");
  el.nrtSheet.setAttribute("aria-hidden", "true");
}

function hydrateProfileForm() {
  el.quitDateInput.value = toDatetimeLocal(state.quitDate);
  el.productTypeInput.value = state.productType;
  el.currencyInput.value = state.currency || "USD";
  el.dailyInput.value = String(state.dailyConsumption);
  el.costInput.value = String(state.costPerPack);
  el.packSizeInput.value = String(state.packSize);
  el.cigaretteStrengthInput.value = normalizeCigaretteStrength(state.cigaretteStrength);
  renderBaselineEstimatePreview();
}

function toDatetimeLocal(isoDate) {
  const d = new Date(isoDate);
  const pad2 = (n) => String(n).padStart(2, "0");
  return `${d.getFullYear()}-${pad2(d.getMonth() + 1)}-${pad2(d.getDate())}T${pad2(d.getHours())}:${pad2(d.getMinutes())}`;
}

function saveProfileForm() {
  const maybeQuitDate = new Date(el.quitDateInput.value);
  if (!Number.isFinite(maybeQuitDate.getTime())) {
    showFeedback("Set a valid quit date/time.");
    return;
  }

  state.quitDate = maybeQuitDate.toISOString();
  if (!state.streakStartAt) state.streakStartAt = state.quitDate;

  state.productType = el.productTypeInput.value;
  state.currency = el.currencyInput.value || "USD";
  state.dailyConsumption = Math.max(1, Number(el.dailyInput.value) || 1);
  state.costPerPack = Math.max(0, Number(el.costInput.value) || 0);
  state.packSize = Math.max(1, Number(el.packSizeInput.value) || 1);
  state.cigaretteStrength = normalizeCigaretteStrength(el.cigaretteStrengthInput.value);
  updateDailyNicotineHistory();

  saveState();
  hydrateNRTControls();
  renderAll();
  queueMissedMilestones();
  closeProfileSheet();
}

function formatPromptDateTimeValue(dateInput) {
  const date = new Date(dateInput);
  if (!Number.isFinite(date.getTime())) return "";
  const pad2 = (n) => String(n).padStart(2, "0");
  return `${date.getFullYear()}-${pad2(date.getMonth() + 1)}-${pad2(date.getDate())} ${pad2(date.getHours())}:${pad2(date.getMinutes())}`;
}

function parsePromptDateTimeValue(rawValue) {
  if (rawValue == null) return null;
  const trimmed = String(rawValue).trim();
  if (!trimmed) return null;

  const isoLike = trimmed
    .replace(/\//g, "-")
    .replace(/\s+/, "T");

  let candidate = new Date(isoLike);
  if (!Number.isFinite(candidate.getTime()) && /^\d{4}-\d{2}-\d{2}$/.test(trimmed)) {
    candidate = new Date(`${trimmed}T09:00`);
  }
  return Number.isFinite(candidate.getTime()) ? candidate : null;
}

function promptResetDateTime(message, fallbackDate) {
  const fallback = formatPromptDateTimeValue(fallbackDate);
  const raw = window.prompt(`${message}\nFormat: YYYY-MM-DD HH:mm`, fallback);
  if (raw == null) return null;
  const parsed = parsePromptDateTimeValue(raw);
  if (!parsed) {
    window.alert("Could not read that date/time. Use format YYYY-MM-DD HH:mm");
    return null;
  }
  return parsed;
}

function promptResetMode() {
  const raw = window.prompt(
    [
      "Reset mode:",
      "1 = Quit now (use current time)",
      "2 = Already quit (enter past quit date/time)",
      "3 = Planning to quit (enter future quit date/time)",
      "",
      "Type 1, 2, or 3"
    ].join("\n"),
    "1"
  );
  if (raw == null) return "";
  const value = String(raw).trim().toLowerCase();
  if (value === "1" || value === "quit now" || value === "now") return "quit_now";
  if (value === "2" || value === "already quit" || value === "already") return "already_quit";
  if (value === "3" || value === "planning" || value === "plan") return "planning_to_quit";
  return "";
}

function clearProgressForFreshRun() {
  state.activeXP = 0;
  state.cravingsResisted = 0;
  state.streakShields = 1;
  state.shieldFragments = 0;
  state.slips = 0;
  state.selectedTrigger = "";
  state.lastChestDate = "";
  state.titleTokens = 0;
  state.dailyRecords = {};
  state.smokeLogByDay = {};
  state.lastWeeklyReviewDate = getTodayKey();
  state.dailyNicotineHistory = {};
  state.nrtLogs = [];
  state.milestoneStatus = {};
  state.milestoneClaimedAt = {};
  state.milestoneClaimedXP = {};
}

function resetProgressFlow() {
  const confirmReset = window.confirm(
    "Reset current progress? This clears XP, levels, milestones, streaks, cravings, slips, and NRT logs. Profile settings and NRT product configs stay."
  );
  if (!confirmReset) return;

  const mode = promptResetMode();
  if (!mode) {
    showFeedback("Reset canceled.");
    return;
  }

  const now = new Date();
  let quitDate = null;
  let modeLabel = "";

  if (mode === "quit_now") {
    quitDate = now;
    modeLabel = "Quit now";
  } else if (mode === "already_quit") {
    const fallback = Number.isFinite(new Date(state.quitDate).getTime())
      ? new Date(state.quitDate)
      : new Date(Date.now() - 24 * 60 * 60 * 1000);
    const picked = promptResetDateTime("Enter when you already quit.", fallback);
    if (!picked) {
      showFeedback("Reset canceled.");
      return;
    }
    if (picked.getTime() > now.getTime()) {
      window.alert("Already quit needs a past date/time. Use planning mode for future quit dates.");
      return;
    }
    quitDate = picked;
    modeLabel = "Already quit";
  } else if (mode === "planning_to_quit") {
    const fallback = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);
    const picked = promptResetDateTime("Enter your planned quit date/time.", fallback);
    if (!picked) {
      showFeedback("Reset canceled.");
      return;
    }
    if (picked.getTime() <= now.getTime()) {
      window.alert("Planning mode needs a future date/time.");
      return;
    }
    quitDate = picked;
    modeLabel = "Planning to quit";
  }

  if (!quitDate) {
    showFeedback("Reset canceled.");
    return;
  }

  clearProgressForFreshRun();
  state.quitDate = quitDate.toISOString();
  state.streakStartAt = state.quitDate;

  if (mode === "planning_to_quit") {
    const quitDay = state.quitDate.slice(0, 10);
    state.nicotinePlan = normalizeNicotinePlan({ ...state.nicotinePlan, startDate: quitDay });
  }

  milestoneQueue = [];
  queueMode = false;
  activeMilestone = null;
  levelUpContinuation = null;
  levelUpSequence = [];
  levelUpSequenceIndex = 0;
  closeMilestoneModal();
  hideLevelUpModal();

  seedDailyQuests();
  updateDailyNicotineHistory();
  saveState();
  hydrateProfileForm();
  hydrateNRTControls();
  hydrateNicotinePlanForm();
  renderAll();
  queueMissedMilestones();

  const quitText = new Date(state.quitDate).toLocaleString();
  showFeedback(`Progress reset (${modeLabel}). Quit date/time: ${quitText}`);
}

function estimateBaselineNicotineFromInputs() {
  const productType = String(el.productTypeInput?.value || state.productType || "cigarettes");
  const usage = Math.max(0, Number(el.dailyInput?.value || state.dailyConsumption || 0));
  const strength = normalizeCigaretteStrength(el.cigaretteStrengthInput?.value || state.cigaretteStrength);
  const mgPerCig = Number(CIGARETTE_STRENGTH_NICOTINE_MG[strength] || CIGARETTE_STRENGTH_NICOTINE_MG.medium);

  if (productType === "cigarettes") return usage * mgPerCig;
  if (productType === "vape") return usage * 1.0;
  return usage * ((mgPerCig + 1.0) / 2);
}

function renderBaselineEstimatePreview() {
  if (!el.baselineEstimateText || !el.cigaretteStrengthInput) return;
  const productType = String(el.productTypeInput?.value || state.productType || "cigarettes");
  const estimate = Math.max(0, estimateBaselineNicotineFromInputs());
  const strength = normalizeCigaretteStrength(el.cigaretteStrengthInput.value || state.cigaretteStrength);
  const strengthLabel = strength.charAt(0).toUpperCase() + strength.slice(1);

  if (productType === "vape") {
    el.cigaretteStrengthInput.disabled = true;
    el.baselineEstimateText.textContent = `Estimated baseline nicotine: ${estimate.toFixed(1)} mg/day (vape session model).`;
    return;
  }

  el.cigaretteStrengthInput.disabled = false;
  if (productType === "both") {
    el.baselineEstimateText.textContent = `Estimated baseline nicotine: ${estimate.toFixed(1)} mg/day (cigarettes + vape model, ${strengthLabel} cigarettes).`;
    return;
  }

  el.baselineEstimateText.textContent = `Estimated baseline nicotine: ${estimate.toFixed(1)} mg/day (${strengthLabel} cigarettes).`;
}

function getNRTProductLabel(product) {
  return NRT_PRODUCT_META[product]?.label || product;
}

function isPatchProduct(product) {
  return product === "patch24" || product === "patch16" || product === "patchCustom";
}

function hydrateNRTControls() {
  state.customPatchProfiles = normalizeCustomPatchProfiles(state.customPatchProfiles);
  state.selectedCustomPatchId = normalizeSelectedCustomPatchId(state.selectedCustomPatchId, state.customPatchProfiles);
  if (el.nrtHistoryQuantityInput && !el.nrtHistoryQuantityInput.value) el.nrtHistoryQuantityInput.value = "1";
  if (el.nrtHistoryDateTimeInput && !el.nrtHistoryDateTimeInput.value) setNRTLogDateTimeToNow();
  if (el.customPatchNameInput && !el.customPatchNameInput.value) el.customPatchNameInput.value = "";
  if (el.customPatchHoursInput && !el.customPatchHoursInput.value) el.customPatchHoursInput.value = "24";
  if (el.customPatchMgInput && !el.customPatchMgInput.value) el.customPatchMgInput.value = "14";
  if (el.customPatchBoxUnitsInput && !el.customPatchBoxUnitsInput.value) el.customPatchBoxUnitsInput.value = "7";
  if (el.customPatchBoxCostInput && !el.customPatchBoxCostInput.value) el.customPatchBoxCostInput.value = "0";

  populateNRTHistoryTypeOptions();
  syncNRTHistoryQuantityInput();
  renderQuickPatchActions();
  renderQuickApplyCustomPatchList();
  renderCustomPatchList();
  renderNRTLogList();
}

function setNRTLogDateTimeToNow() {
  if (!el.nrtHistoryDateTimeInput) return;
  el.nrtHistoryDateTimeInput.value = toDatetimeLocal(new Date().toISOString());
}

function syncNRTHistoryQuantityInput() {
  if (!el.nrtHistoryQuantityInput) return;
  const selectedType = String(el.nrtHistoryTypeSelect?.value || "");
  const isPatchType = selectedType.startsWith("custom:") || isPatchProduct(selectedType);
  if (isPatchType) {
    el.nrtHistoryQuantityInput.value = "1";
    el.nrtHistoryQuantityInput.disabled = true;
    el.nrtHistoryQuantityInput.title = "Patch entries are one patch per log.";
    return;
  }
  el.nrtHistoryQuantityInput.disabled = false;
  el.nrtHistoryQuantityInput.title = "";
}

function getSelectedNRTLogTimestampISO() {
  const raw = String(el.nrtHistoryDateTimeInput?.value || "").trim();
  if (!raw) return new Date().toISOString();
  const parsed = new Date(raw);
  if (!Number.isFinite(parsed.getTime())) {
    showFeedback("Invalid log date/time. Using current time.");
    return new Date().toISOString();
  }
  return parsed.toISOString();
}

function populateNRTHistoryTypeOptions() {
  if (!el.nrtHistoryTypeSelect) return;
  const previous = String(el.nrtHistoryTypeSelect.value || "");
  const options = [
    { value: "gum", label: "Gum" },
    { value: "lozenge", label: "Lozenge" },
    { value: "spray", label: "Spray" },
    { value: "patch24", label: `Built-in Patch 24h (${getNRTConfig("patch24").mgPerUnit} mg)` },
    { value: "patch16", label: `Built-in Patch 16h (${getNRTConfig("patch16").mgPerUnit} mg)` }
  ];

  getCustomPatchProfiles().forEach((profile) => {
    const unitCost = getCustomPatchUnitCost(profile);
    options.push({
      value: `custom:${profile.id}`,
      label: `${profile.label} • ${profile.hours}h • ${Number(profile.mgPerUnit).toFixed(1)} mg • ${formatMoney(unitCost)}/patch`
    });
  });

  el.nrtHistoryTypeSelect.innerHTML = "";
  options.forEach((opt) => {
    const option = document.createElement("option");
    option.value = opt.value;
    option.textContent = opt.label;
    el.nrtHistoryTypeSelect.appendChild(option);
  });

  const valid = options.some((opt) => opt.value === previous);
  if (valid) el.nrtHistoryTypeSelect.value = previous;
  syncNRTHistoryQuantityInput();
}

function saveCustomPatchProfile() {
  const rawName = String(el.customPatchNameInput?.value || "").trim();
  const hours = Math.max(1, Math.round(Number(el.customPatchHoursInput?.value || 0)));
  const mgPerUnit = Math.max(0.1, Number(el.customPatchMgInput?.value || 0));
  const unitsPerBox = Math.max(1, Math.round(Number(el.customPatchBoxUnitsInput?.value || 0)));
  const boxCost = Math.max(0, Number(el.customPatchBoxCostInput?.value || 0));

  if (!rawName) {
    showFeedback("Enter a profile name.");
    return null;
  }
  if (!Number.isFinite(hours) || !Number.isFinite(mgPerUnit) || !Number.isFinite(unitsPerBox) || !Number.isFinite(boxCost)) {
    showFeedback("Set valid custom patch values.");
    return null;
  }

  const profile = {
    id: `cp-${Date.now()}-${Math.random().toString(16).slice(2, 7)}`,
    label: rawName,
    hours,
    mgPerUnit,
    unitsPerBox,
    boxCost
  };

  const normalizedName = profile.label.trim().toLowerCase();
  const existing = getCustomPatchProfiles().find((item) =>
    String(item.label || "").trim().toLowerCase() === normalizedName &&
    item.hours === profile.hours &&
    Math.abs(Number(item.mgPerUnit) - Number(profile.mgPerUnit)) < 0.001 &&
    item.unitsPerBox === profile.unitsPerBox &&
    Math.abs(Number(item.boxCost) - Number(profile.boxCost)) < 0.001
  );

  if (existing) {
    state.selectedCustomPatchId = existing.id;
    saveState();
    populateNRTHistoryTypeOptions();
    renderQuickApplyCustomPatchList();
    renderCustomPatchList();
    showFeedback(`Custom patch already exists: ${getCustomPatchLabel(existing)}.`);
    return existing;
  }

  state.customPatchProfiles.push(profile);
  state.customPatchProfiles = normalizeCustomPatchProfiles(state.customPatchProfiles);
  state.selectedCustomPatchId = profile.id;
  saveState();
  populateNRTHistoryTypeOptions();
  renderQuickApplyCustomPatchList();
  renderCustomPatchList();
  showFeedback(`Saved custom patch: ${getCustomPatchLabel(profile)}.`);
  return profile;
}

function applyCustomPatchProfile(profileId) {
  const profile = getCustomPatchProfileById(profileId || state.selectedCustomPatchId);
  if (!profile) {
    showFeedback("Create a custom patch profile first.");
    return null;
  }

  state.selectedCustomPatchId = profile.id;
  saveState();

  const unitCost = getCustomPatchUnitCost(profile);
  const timestampISO = getSelectedNRTLogTimestampISO();
  const log = logNRTUsage("patchCustom", 1, {
    nicotineMg: profile.mgPerUnit,
    cost: unitCost,
    timestampISO,
    patchProfileId: profile.id,
    patchHours: profile.hours,
    patchLabel: getCustomPatchLabel(profile)
  });
  showFeedback(`${getCustomPatchLabel(profile)} applied. Nicotine +${log.nicotineMg.toFixed(1)} mg, cost +${formatMoney(log.cost)}.`);
  return log;
}

function removeCustomPatchProfile(profileId) {
  const id = String(profileId || "");
  if (!id) return;

  const before = getCustomPatchProfiles();
  const next = before.filter((item) => item.id !== id);
  if (next.length === before.length) return;

  state.customPatchProfiles = next;
  state.selectedCustomPatchId = normalizeSelectedCustomPatchId(state.selectedCustomPatchId === id ? "" : state.selectedCustomPatchId, next);
  saveState();
  populateNRTHistoryTypeOptions();
  renderQuickApplyCustomPatchList();
  renderCustomPatchList();
  showFeedback("Custom patch removed.");
}

function createNRTUsageLog(product, quantity, options = {}) {
  const safeProduct = NRT_PRODUCTS.includes(product) ? product : "gum";
  const safeQuantity = Math.max(1, Math.round(Number(quantity) || 1));
  const config = getNRTConfig(safeProduct);
  const unitCost = Math.max(0, Number(config.packCost || 0)) / Math.max(1, Number(config.unitsPerPack || 1));
  const overrideNicotine = Number(options.nicotineMg);
  const overrideCost = Number(options.cost);
  const timestampCandidate = options.timestampISO ? new Date(options.timestampISO) : new Date();
  const timestampISO = Number.isFinite(timestampCandidate.getTime()) ? timestampCandidate.toISOString() : new Date().toISOString();
  const log = {
    id: `log-${Date.now()}-${Math.random().toString(16).slice(2, 8)}`,
    timestamp: timestampISO,
    product: safeProduct,
    quantity: safeQuantity,
    nicotineMg: Number((Number.isFinite(overrideNicotine) ? overrideNicotine : safeQuantity * Number(config.mgPerUnit || 0)).toFixed(2)),
    cost: Number((Number.isFinite(overrideCost) ? overrideCost : safeQuantity * unitCost).toFixed(2)),
    patchProfileId: options.patchProfileId ? String(options.patchProfileId) : "",
    patchHours: Math.max(0, Math.round(Number(options.patchHours || 0))),
    patchLabel: options.patchLabel ? String(options.patchLabel) : ""
  };
  return log;
}

function logNRTUsage(product, quantity = 1, options = {}) {
  const log = createNRTUsageLog(product, quantity, options);
  state.nrtLogs.push(log);
  if (state.nrtLogs.length > 500) {
    state.nrtLogs = state.nrtLogs.slice(-500);
  }

  updateDailyNicotineHistory();
  saveState();
  renderAll();
  queueMissedMilestones();
  return log;
}

function saveNRTUsageLog() {
  const selectedType = String(el.nrtHistoryTypeSelect?.value || "gum");
  const quantityInput = Math.max(1, Math.round(Number(el.nrtHistoryQuantityInput?.value || 1)));
  const timestampISO = getSelectedNRTLogTimestampISO();

  if (selectedType.startsWith("custom:")) {
    const profileId = selectedType.slice("custom:".length);
    const profile = getCustomPatchProfileById(profileId);
    if (!profile) {
      showFeedback("Selected patch profile no longer exists.");
      populateNRTHistoryTypeOptions();
      return null;
    }

    const unitCost = getCustomPatchUnitCost(profile);
    const log = logNRTUsage("patchCustom", 1, {
      nicotineMg: profile.mgPerUnit,
      cost: unitCost,
      timestampISO,
      patchProfileId: profile.id,
      patchHours: profile.hours,
      patchLabel: getCustomPatchLabel(profile)
    });
    if (el.nrtHistoryQuantityInput) el.nrtHistoryQuantityInput.value = "1";
    showFeedback(`${getCustomPatchLabel(profile)} logged at ${new Date(log.timestamp).toLocaleString()}.`);
    return log;
  }

  const product = NRT_PRODUCTS.includes(selectedType) ? selectedType : "gum";
  const quantity = isPatchProduct(product) ? 1 : quantityInput;
  if (!isPatchProduct(product) && quantity > 10) {
    const proceed = window.confirm(`Log ${quantity} ${getNRTProductLabel(product)} units at ${new Date(timestampISO).toLocaleString()}?`);
    if (!proceed) return null;
  }

  const log = logNRTUsage(product, quantity, { timestampISO });
  if (el.nrtHistoryQuantityInput) el.nrtHistoryQuantityInput.value = "1";
  showFeedback(`${getNRTProductLabel(product)} logged (${quantity} unit${quantity === 1 ? "" : "s"}) at ${new Date(log.timestamp).toLocaleString()}.`);
  return log;
}

function undoLastNRTLog() {
  if (!Array.isArray(state.nrtLogs) || !state.nrtLogs.length) {
    showFeedback("No NRT log to undo.");
    return;
  }
  const removed = state.nrtLogs.pop();
  updateDailyNicotineHistory();
  saveState();
  renderAll();
  showFeedback(`Removed last log: ${getNRTProductLabel(removed.product)} x${removed.quantity}.`);
}

function logQuickPatch(product) {
  const safeProduct = product === "patch16" ? "patch16" : "patch24";
  const timestampISO = getSelectedNRTLogTimestampISO();
  const log = logNRTUsage(safeProduct, 1, { timestampISO });
  const label = getNRTProductLabel(safeProduct);
  showFeedback(`${label} applied at ${new Date(log.timestamp).toLocaleString()}. Nicotine +${log.nicotineMg.toFixed(1)} mg, cost +${formatMoney(log.cost)}.`);
}

function renderQuickPatchActions() {
  if (!el.quickLogPatch24 || !el.quickLogPatch16 || !el.quickPatchInfo) return;

  const patch24 = getNRTConfig("patch24");
  const patch16 = getNRTConfig("patch16");
  const unitCost24 = Math.max(0, Number(patch24.packCost || 0)) / Math.max(1, Number(patch24.unitsPerPack || 1));
  const unitCost16 = Math.max(0, Number(patch16.packCost || 0)) / Math.max(1, Number(patch16.unitsPerPack || 1));

  el.quickLogPatch24.textContent = `Applied Patch 24h (+${patch24.mgPerUnit} mg)`;
  el.quickLogPatch16.textContent = `Applied Patch 16h (+${patch16.mgPerUnit} mg)`;
  el.quickPatchInfo.textContent = `Saved patch costs: 24h ${formatMoney(unitCost24)} each, 16h ${formatMoney(unitCost16)} each. Patch logs are one-tap to avoid accidental multi-patch entries.`;
}

function renderQuickApplyCustomPatchList() {
  if (!el.quickApplyCustomPatchList) return;
  const profiles = getCustomPatchProfiles();

  if (!profiles.length) {
    el.quickApplyCustomPatchList.innerHTML = `<p class="subtle">No saved patch profiles yet. Create one in Patch Profiles.</p>`;
    return;
  }

  el.quickApplyCustomPatchList.innerHTML = "";
  profiles.forEach((profile) => {
    const unitCost = getCustomPatchUnitCost(profile);
    const item = document.createElement("article");
    item.className = "mile";
    item.innerHTML = `
      <div class="mile-head">
        <p class="mile-title">${getCustomPatchLabel(profile)}</p>
        <span class="pill">${formatMoney(unitCost)}/patch</span>
      </div>
      <p class="mile-meta">${profile.unitsPerBox} per box • ${formatMoney(profile.boxCost)} box cost</p>
      <button class="primary-btn" data-apply-custom-patch-id="${profile.id}" style="margin-top:8px;">Apply Now / At Selected Time</button>
    `;
    el.quickApplyCustomPatchList.appendChild(item);
  });
}

function renderCustomPatchList() {
  if (!el.customPatchList) return;
  const profiles = getCustomPatchProfiles();

  if (!profiles.length) {
    el.customPatchList.innerHTML = `<p class="subtle">No custom patch profiles yet. Add one above, then tap Apply daily.</p>`;
    return;
  }

  el.customPatchList.innerHTML = "";
  profiles.forEach((profile) => {
    const unitCost = getCustomPatchUnitCost(profile);
    const selected = state.selectedCustomPatchId === profile.id;
    const item = document.createElement("article");
    item.className = "mile";
    item.innerHTML = `
      <div class="mile-head">
        <p class="mile-title">${getCustomPatchLabel(profile)}</p>
        <span class="pill">${formatMoney(unitCost)}/patch</span>
      </div>
      <p class="mile-meta">${profile.unitsPerBox} per box • ${formatMoney(profile.boxCost)} box cost ${selected ? "• Selected" : ""}</p>
      <div class="rescue-actions" style="margin-top:8px;">
        <button class="secondary-btn" data-select-custom-patch-id="${profile.id}">Set Default</button>
        <button class="danger-btn" data-remove-custom-patch-id="${profile.id}">Remove</button>
      </div>
    `;
    el.customPatchList.appendChild(item);
  });
}

function renderNRTLogList() {
  if (!el.nrtLogList) return;
  const sorted = [...(state.nrtLogs || [])]
    .sort((a, b) => new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime())
    .slice(0, 20);

  if (!sorted.length) {
    el.nrtLogList.innerHTML = `<p class="subtle">No NRT logs yet. Log current or historical entries to track nicotine and cost by day.</p>`;
    return;
  }

  el.nrtLogList.innerHTML = "";
  sorted.forEach((log) => {
    const productLabel = log.product === "patchCustom"
      ? (log.patchLabel || `${Math.max(0, Number(log.patchHours || 0)) || "?"}h Patch`)
      : getNRTProductLabel(log.product);
    const when = new Date(log.timestamp);
    const item = document.createElement("article");
    item.className = "mile";
    item.innerHTML = `
      <div class="mile-head">
        <p class="mile-title">${productLabel} x${log.quantity}</p>
        <span class="pill">${log.nicotineMg.toFixed(1)} mg</span>
      </div>
      <p class="mile-meta">${when.toLocaleDateString()} ${when.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" })}</p>
      <p class="mile-desc">Cost: ${formatMoney(log.cost)}</p>
    `;
    el.nrtLogList.appendChild(item);
  });
}

function getPlanPhaseInputRefs() {
  return [
    { mg: el.planPhase1Mg, days: el.planPhase1Days },
    { mg: el.planPhase2Mg, days: el.planPhase2Days },
    { mg: el.planPhase3Mg, days: el.planPhase3Days },
    { mg: el.planPhase4Mg, days: el.planPhase4Days }
  ];
}

function hydrateNicotinePlanForm() {
  if (!el.planStartDateInput) return;

  state.nicotinePlan = normalizeNicotinePlan(state.nicotinePlan);
  el.planStartDateInput.value = state.nicotinePlan.startDate;

  const refs = getPlanPhaseInputRefs();
  refs.forEach((ref, idx) => {
    const phase = state.nicotinePlan.phases[idx] || { mgPerDay: 0, days: 0 };
    ref.mg.value = String(phase.mgPerDay);
    ref.days.value = String(phase.days);
  });
}

function saveNicotinePlanFromForm() {
  if (!el.planStartDateInput) return;

  const startDate = isDayKey(el.planStartDateInput.value) ? el.planStartDateInput.value : getTodayKey();
  const refs = getPlanPhaseInputRefs();
  const phases = refs.map((ref) => ({
    mgPerDay: Math.max(0, Number(ref.mg.value) || 0),
    days: Math.max(0, Math.round(Number(ref.days.value) || 0))
  }));

  state.nicotinePlan = normalizeNicotinePlan({ startDate, phases });
  saveState();
  renderAll();
  showFeedback("Nicotine taper plan saved.");
}

function applyExampleNicotinePlan() {
  const quitDateKey = new Date(state.quitDate).toISOString().slice(0, 10);
  state.nicotinePlan = normalizeNicotinePlan({
    startDate: quitDateKey,
    phases: [
      { mgPerDay: 14, days: 10 },
      { mgPerDay: 15, days: 6 },
      { mgPerDay: 15, days: 8 },
      { mgPerDay: 7, days: 28 }
    ]
  });
  hydrateNicotinePlanForm();
  saveState();
  renderAll();
  showFeedback("Example plan applied: 14mg x10d -> 15mg x6d -> 15mg x8d -> 7mg x28d.");
}

function getActualNicotineByDayMap() {
  const map = {};
  (state.nrtLogs || []).forEach((log) => {
    const day = getLogDayKey(log);
    if (!day) return;
    map[day] = (Number(map[day]) || 0) + Math.max(0, Number(log.nicotineMg || 0));
  });
  return map;
}

function getPlannedNicotineByDayMap() {
  const plan = normalizeNicotinePlan(state.nicotinePlan);
  const map = {};
  let cursor = plan.startDate;

  plan.phases.forEach((phase) => {
    const mg = Math.max(0, Number(phase.mgPerDay || 0));
    const days = Math.max(0, Math.round(Number(phase.days || 0)));
    for (let i = 0; i < days; i += 1) {
      map[cursor] = mg;
      cursor = addDaysToDayKey(cursor, 1);
    }
  });

  return map;
}

function getNicotineTrendSeries() {
  const actual = getActualNicotineByDayMap();
  const planned = getPlannedNicotineByDayMap();

  const allKeys = [...new Set([...Object.keys(actual), ...Object.keys(planned)])];

  if (!allKeys.length) {
    const today = getTodayKey();
    return [{ dayKey: today, mg: 0, source: "none" }];
  }

  const sortedKeys = [...allKeys].sort();
  let start = sortedKeys[0];
  let end = sortedKeys[sortedKeys.length - 1];
  const today = getTodayKey();
  if (today < start) start = today;
  if (today > end) end = today;

  let spanGuard = 0;
  let spanStart = start;
  while (spanStart < end && spanGuard < 365) {
    spanStart = addDaysToDayKey(spanStart, 1);
    spanGuard += 1;
  }
  if (spanGuard >= 90) {
    start = addDaysToDayKey(end, -89);
  }

  const series = [];
  let cursor = start;
  let guard = 0;
  while (cursor <= end && guard < 120) {
    if (actual[cursor] != null) {
      series.push({ dayKey: cursor, mg: Number(actual[cursor]) || 0, source: "actual" });
    } else if (planned[cursor] != null) {
      series.push({ dayKey: cursor, mg: Number(planned[cursor]) || 0, source: "planned" });
    } else {
      series.push({ dayKey: cursor, mg: 0, source: "none" });
    }
    cursor = addDaysToDayKey(cursor, 1);
    guard += 1;
  }

  return series;
}

function formatDayLabel(dayKey) {
  const date = parseDayKey(dayKey);
  if (!date) return dayKey;
  return `${date.getUTCMonth() + 1}/${date.getUTCDate()}`;
}

function renderNicotineTrendChart() {
  if (!el.nicotineTrendChart) return;

  const series = getNicotineTrendSeries();
  const canvas = el.nicotineTrendChart;
  const ctx = canvas.getContext("2d");
  if (!ctx) return;

  const cssWidth = Math.max(280, canvas.clientWidth || 320);
  const cssHeight = Number(canvas.getAttribute("height") || 220);
  const dpr = window.devicePixelRatio || 1;

  canvas.width = Math.floor(cssWidth * dpr);
  canvas.height = Math.floor(cssHeight * dpr);
  ctx.setTransform(1, 0, 0, 1, 0, 0);
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  ctx.setTransform(dpr, 0, 0, dpr, 0, 0);

  const pad = { left: 34, right: 10, top: 14, bottom: 24 };
  const plotW = cssWidth - pad.left - pad.right;
  const plotH = cssHeight - pad.top - pad.bottom;
  const maxMg = Math.max(1, ...series.map((s) => s.mg));
  const stepX = plotW / Math.max(1, series.length);
  const barW = Math.max(1.2, stepX * 0.72);
  const today = getTodayKey();

  ctx.font = "11px SF Pro Display, sans-serif";
  ctx.textBaseline = "middle";

  [0, 0.5, 1].forEach((ratio) => {
    const y = pad.top + plotH * (1 - ratio);
    ctx.strokeStyle = "rgba(16, 37, 59, 0.12)";
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(pad.left, y);
    ctx.lineTo(pad.left + plotW, y);
    ctx.stroke();

    const label = `${Math.round(maxMg * ratio)}mg`;
    ctx.fillStyle = "rgba(16, 37, 59, 0.62)";
    ctx.fillText(label, 2, y);
  });

  series.forEach((point, idx) => {
    const mg = Math.max(0, Number(point.mg || 0));
    const h = (mg / maxMg) * plotH;
    const x = pad.left + idx * stepX + (stepX - barW) / 2;
    const y = pad.top + plotH - h;

    if (point.source === "actual") {
      ctx.fillStyle = "rgba(25, 213, 196, 0.88)";
    } else if (point.source === "planned" && point.dayKey > today) {
      ctx.fillStyle = "rgba(255, 122, 47, 0.86)";
    } else if (point.source === "planned") {
      ctx.fillStyle = "rgba(255, 122, 47, 0.58)";
    } else {
      ctx.fillStyle = "rgba(16, 37, 59, 0.1)";
    }

    ctx.fillRect(x, y, barW, Math.max(1, h));
  });

  const todayIndex = series.findIndex((s) => s.dayKey === today);
  if (todayIndex >= 0) {
    const x = pad.left + todayIndex * stepX + stepX / 2;
    ctx.strokeStyle = "rgba(16, 37, 59, 0.8)";
    ctx.lineWidth = 1.3;
    ctx.beginPath();
    ctx.moveTo(x, pad.top - 2);
    ctx.lineTo(x, pad.top + plotH + 2);
    ctx.stroke();
  }

  const labelIndexes = [0, Math.floor((series.length - 1) / 2), series.length - 1];
  const printed = new Set();
  ctx.fillStyle = "rgba(16, 37, 59, 0.72)";
  ctx.textBaseline = "top";
  labelIndexes.forEach((idx) => {
    if (idx < 0 || idx >= series.length || printed.has(idx)) return;
    printed.add(idx);
    const x = pad.left + idx * stepX + stepX / 2;
    const label = formatDayLabel(series[idx].dayKey);
    ctx.fillText(label, Math.max(2, x - 12), pad.top + plotH + 6);
  });

  const nonZero = series.filter((s) => s.mg > 0);
  if (el.nicotineTrendSummary) {
    if (!nonZero.length) {
      el.nicotineTrendSummary.textContent = "No nicotine data yet. Start logging NRT or set a plan to see trend.";
    } else {
      const startMg = nonZero[0].mg;
      const endMg = nonZero[nonZero.length - 1].mg;
      const reductionPct = startMg > 0 ? Math.round(((startMg - endMg) / startMg) * 100) : 0;
      const actualDays = series.filter((s) => s.source === "actual").length;
      const plannedDays = series.filter((s) => s.source === "planned").length;
      el.nicotineTrendSummary.textContent = `Trend: ${startMg.toFixed(1)} -> ${endMg.toFixed(1)} mg/day (${reductionPct}% down). Actual logged days: ${actualDays}. Planned days: ${plannedDays}.`;
    }
  }
}

function wireNRTConfigActions() {
  if (el.nrtHistoryLogBtn) el.nrtHistoryLogBtn.addEventListener("click", saveNRTUsageLog);
  if (el.nrtHistoryUseNowBtn) el.nrtHistoryUseNowBtn.addEventListener("click", setNRTLogDateTimeToNow);
  if (el.nrtHistoryTypeSelect) el.nrtHistoryTypeSelect.addEventListener("change", syncNRTHistoryQuantityInput);
  if (el.undoLastNRTLog) el.undoLastNRTLog.addEventListener("click", undoLastNRTLog);
  if (el.quickLogPatch24) el.quickLogPatch24.addEventListener("click", () => logQuickPatch("patch24"));
  if (el.quickLogPatch16) el.quickLogPatch16.addEventListener("click", () => logQuickPatch("patch16"));

  if (el.quickApplyCustomPatchList) {
    el.quickApplyCustomPatchList.addEventListener("click", (event) => {
      const target = event.target;
      if (!(target instanceof HTMLElement)) return;
      const applyId = target.dataset.applyCustomPatchId;
      if (!applyId) return;
      applyCustomPatchProfile(applyId);
    });
  }

  if (el.saveCustomPatch) el.saveCustomPatch.addEventListener("click", saveCustomPatchProfile);
  if (el.customPatchList) {
    el.customPatchList.addEventListener("click", (event) => {
      const target = event.target;
      if (!(target instanceof HTMLElement)) return;
      const selectId = target.dataset.selectCustomPatchId;
      if (selectId) {
        state.selectedCustomPatchId = selectId;
        saveState();
        populateNRTHistoryTypeOptions();
        renderQuickApplyCustomPatchList();
        renderCustomPatchList();
        showFeedback("Custom patch selected.");
        return;
      }
      const removeId = target.dataset.removeCustomPatchId;
      if (removeId) {
        const confirmDelete = window.confirm("Remove this custom patch profile?");
        if (!confirmDelete) return;
        removeCustomPatchProfile(removeId);
      }
    });
  }
  if (el.saveNicotinePlan) el.saveNicotinePlan.addEventListener("click", saveNicotinePlanFromForm);
  if (el.applyExamplePlan) el.applyExamplePlan.addEventListener("click", applyExampleNicotinePlan);
}

function getMilestoneSortValue(m) {
  if (typeof m.prepOrder === "number") return m.prepOrder;
  if (typeof m.reductionPct === "number") return m.reductionPct;
  if (typeof m.hours === "number") return m.hours;
  if (typeof m.targetNicotineMg === "number") return m.targetNicotineMg;
  if (typeof m.amount === "number") return m.amount;
  if (typeof m.count === "number") return m.count;
  return 999999;
}

function showLevelUpModal(data) {
  const level = Number(data?.level || 1);
  const progress = Math.max(0, Math.min(1, Number(data?.progress || 0)));
  const progressPct = Math.round(progress * 100);
  const xpToNext = Math.max(0, Number(data?.xpToNext || 0));
  const leveledUp = Boolean(data?.leveledUp);
  const milestoneTitle = String(data?.milestoneTitle || "Milestone unlocked");
  const milestoneXP = Math.max(0, Number(data?.milestoneXP || 0));

  el.levelUpTitle.textContent = leveledUp ? "Level Up" : "Milestone Unlocked";
  el.levelUpMilestone.textContent = `${milestoneTitle} • +${milestoneXP} XP`;
  el.levelUpText.textContent = `Level ${level}`;
  el.levelUpProgressText.textContent = `${progressPct}% to Level ${Math.min(100, level + 1)} • ${xpToNext} XP to go`;
  el.levelUpProgressFill.style.width = `${progressPct}%`;
  el.levelUpModal.classList.remove("hidden");
  el.levelUpModal.setAttribute("aria-hidden", "false");
}

function hideLevelUpModal() {
  el.levelUpModal.classList.add("hidden");
  el.levelUpModal.setAttribute("aria-hidden", "true");
}

function openMilestoneModal(milestone, fromQueue = false) {
  activeMilestone = milestone;
  queueMode = fromQueue;
  const unlockXP = getMilestoneUnlockXP(milestone);
  el.milestoneModalTitle.textContent = milestone.title;
  el.milestoneModalDesc.textContent = milestone.desc;
  el.milestoneModalMeta.textContent = `+${unlockXP} XP`;
  el.milestoneModal.classList.remove("hidden");
  el.milestoneModal.setAttribute("aria-hidden", "false");
}

function closeMilestoneModal() {
  el.milestoneModal.classList.add("hidden");
  el.milestoneModal.setAttribute("aria-hidden", "true");
}

function proceedMilestoneFlow() {
  if (queueMode) {
    showNextMilestoneFromQueue();
    return;
  }
  activeMilestone = null;
}

function collectReadyMilestones() {
  return getAllMilestones()
    .filter((m) => isMilestoneUnlocked(m) && !isMilestoneClaimed(m.id) && !isMilestoneSkipped(m.id))
    .sort((a, b) => getMilestoneSortValue(a) - getMilestoneSortValue(b));
}

function collectModalContextMilestones() {
  const source = queueMode ? [activeMilestone, ...milestoneQueue] : [activeMilestone, ...collectReadyMilestones()];
  const deduped = new Map();
  source.forEach((m) => {
    if (!m || !m.id) return;
    if (!deduped.has(m.id)) deduped.set(m.id, m);
  });
  return [...deduped.values()].filter((m) => isMilestoneUnlocked(m) && !isMilestoneClaimed(m.id));
}

function claimMilestoneForCelebration(milestone) {
  if (!milestone || !isMilestoneUnlocked(milestone) || isMilestoneClaimed(milestone.id)) return null;

  const unlockXP = getMilestoneUnlockXP(milestone);
  const before = getLevelData(getTotalXP());
  state.activeXP += unlockXP;
  setMilestoneStatus(milestone.id, "claimed");
  state.milestoneClaimedAt[milestone.id] = new Date().toISOString();
  state.milestoneClaimedXP[milestone.id] = unlockXP;
  const after = getLevelData(getTotalXP());

  return {
    level: after.level,
    progress: after.progress,
    xpToNext: after.xpToNext,
    leveledUp: after.level > before.level,
    milestoneTitle: milestone.title,
    milestoneXP: unlockXP
  };
}

function finishLevelUpSequence() {
  levelUpSequence = [];
  levelUpSequenceIndex = 0;
  hideLevelUpModal();
  if (typeof levelUpContinuation === "function") {
    const next = levelUpContinuation;
    levelUpContinuation = null;
    next();
  }
}

function startLevelUpSequence(entries, onDone = null) {
  levelUpSequence = Array.isArray(entries) ? entries.filter(Boolean) : [];
  levelUpSequenceIndex = 0;
  levelUpContinuation = typeof onDone === "function" ? onDone : null;
  if (!levelUpSequence.length) {
    finishLevelUpSequence();
    return;
  }
  showLevelUpModal(levelUpSequence[0]);
}

function continueLevelUpSequence() {
  if (!levelUpSequence.length) {
    finishLevelUpSequence();
    return;
  }

  levelUpSequenceIndex += 1;
  if (levelUpSequenceIndex >= levelUpSequence.length) {
    finishLevelUpSequence();
    return;
  }
  showLevelUpModal(levelUpSequence[levelUpSequenceIndex]);
}

function skipRemainingLevelUpSequence() {
  finishLevelUpSequence();
}

function unlockActiveMilestone() {
  if (!activeMilestone) return;
  const milestone = activeMilestone;
  if (isMilestoneClaimed(milestone.id)) {
    closeMilestoneModal();
    proceedMilestoneFlow();
    return;
  }

  const celebration = claimMilestoneForCelebration(milestone);
  if (!celebration) {
    closeMilestoneModal();
    proceedMilestoneFlow();
    return;
  }

  saveState();
  closeMilestoneModal();
  renderAll();
  startLevelUpSequence([celebration], proceedMilestoneFlow);
}

function unlockAllReadyMilestones() {
  const targets = collectModalContextMilestones();
  if (!targets.length) {
    showFeedback("No ready milestones to unlock.");
    closeMilestoneModal();
    proceedMilestoneFlow();
    return;
  }

  const celebrations = targets.map((m) => claimMilestoneForCelebration(m)).filter(Boolean);
  milestoneQueue = [];
  queueMode = false;
  activeMilestone = null;
  closeMilestoneModal();
  saveState();
  renderAll();
  startLevelUpSequence(celebrations);
}

function skipAllReadyMilestones() {
  const targets = collectModalContextMilestones();
  if (!targets.length) {
    showFeedback("No ready milestones to skip.");
    closeMilestoneModal();
    proceedMilestoneFlow();
    return;
  }

  let skippedCount = 0;
  targets.forEach((milestone) => {
    if (!milestone || !isMilestoneUnlocked(milestone) || isMilestoneClaimed(milestone.id) || isMilestoneSkipped(milestone.id)) return;
    setMilestoneStatus(milestone.id, "skipped");
    clearMilestoneClaimMeta(milestone.id);
    skippedCount += 1;
  });

  milestoneQueue = [];
  queueMode = false;
  activeMilestone = null;
  closeMilestoneModal();
  saveState();
  renderAll();
  showFeedback(`Skipped ${skippedCount} ready milestone${skippedCount === 1 ? "" : "s"}.`);
}

function skipActiveMilestone() {
  if (!activeMilestone) return;
  setMilestoneStatus(activeMilestone.id, "skipped");
  clearMilestoneClaimMeta(activeMilestone.id);
  saveState();
  closeMilestoneModal();
  renderAll();
  proceedMilestoneFlow();
}

function showNextMilestoneFromQueue() {
  if (!milestoneQueue.length) {
    queueMode = false;
    activeMilestone = null;
    return;
  }

  const next = milestoneQueue.shift();
  openMilestoneModal(next, true);
}

function queueMissedMilestones() {
  if (!el.milestoneModal || !el.levelUpModal) return;
  if (!el.milestoneModal.classList.contains("hidden") || !el.levelUpModal.classList.contains("hidden")) return;

  const ready = getAllMilestones()
    .filter((m) => isMilestoneUnlocked(m) && !isMilestoneClaimed(m.id) && !isMilestoneSkipped(m.id))
    .sort((a, b) => getMilestoneSortValue(a) - getMilestoneSortValue(b));

  if (!ready.length) return;

  milestoneQueue = ready;
  queueMode = true;
  showNextMilestoneFromQueue();
}

function wireMilestoneActions() {
  el.milestoneList.addEventListener("click", (event) => {
    const target = event.target;
    if (!(target instanceof HTMLElement)) return;
    if (!target.matches("button[data-unlock-id]")) return;

    const id = target.dataset.unlockId;
    const milestone = getAllMilestones().find((m) => m.id === id);
    if (!milestone || !isMilestoneUnlocked(milestone) || isMilestoneClaimed(milestone.id)) return;
    openMilestoneModal(milestone, false);
  });

  el.milestoneUnlockBtn.addEventListener("click", unlockActiveMilestone);
  if (el.milestoneUnlockAllBtn) el.milestoneUnlockAllBtn.addEventListener("click", unlockAllReadyMilestones);
  el.milestoneSkipBtn.addEventListener("click", skipActiveMilestone);
  if (el.milestoneSkipAllBtn) el.milestoneSkipAllBtn.addEventListener("click", skipAllReadyMilestones);
  el.levelUpContinueBtn.addEventListener("click", continueLevelUpSequence);
  if (el.levelUpSkipBtn) el.levelUpSkipBtn.addEventListener("click", skipRemainingLevelUpSequence);
}

function wireCravingActions() {
  document.getElementById("startRescue").addEventListener("click", startRescue);
  document.getElementById("logResisted").addEventListener("click", logResistedCraving);
  document.getElementById("logSlip").addEventListener("click", logSlip);

  document.querySelectorAll(".trigger").forEach((btn) => {
    btn.addEventListener("click", () => {
      document.querySelectorAll(".trigger").forEach((b) => b.classList.remove("active"));
      btn.classList.add("active");
      state.selectedTrigger = btn.dataset.trigger;
      el.selectedTrigger.textContent = `Trigger: ${state.selectedTrigger}`;
      saveState();
    });
  });

  if (state.selectedTrigger) {
    const match = document.querySelector(`.trigger[data-trigger="${CSS.escape(state.selectedTrigger)}"]`);
    if (match) match.classList.add("active");
    el.selectedTrigger.textContent = `Trigger: ${state.selectedTrigger}`;
  }
}

function startRescue() {
  if (rescueRunning) return;

  rescueRunning = true;
  rescueRemaining = 90;
  renderRescueRing();
  showFeedback("Rescue started. Breathe slow: in 4, hold 4, out 6.");

  rescueInterval = setInterval(() => {
    rescueRemaining -= 1;
    renderRescueRing();

    if (rescueRemaining <= 0) {
      clearInterval(rescueInterval);
      rescueRunning = false;
      awardXP(45, "Rescue complete");
      maybeOpenMysteryChest(0.4);
      saveState();
      renderAll();
      showFeedback("Craving wave passed. Huge win.");
    }
  }, 1000);
}

function renderRescueRing() {
  const total = 90;
  const done = total - rescueRemaining;
  const progress = Math.max(0, Math.min(1, done / total));
  el.rescueRing.style.setProperty("--rescue-progress", String(progress));

  const mins = Math.floor(Math.max(0, rescueRemaining) / 60);
  const secs = Math.max(0, rescueRemaining) % 60;
  el.rescueTime.textContent = `${pad(mins)}:${pad(secs)}`;
}

function wireQuestActions() {
  el.questList.addEventListener("click", (event) => {
    const target = event.target;
    if (!(target instanceof HTMLElement)) return;
    if (target.matches("button[data-quest-id]")) {
      completeQuest(target.dataset.questId);
    }
  });
}

function wireFilters() {
  document.querySelectorAll(".filter").forEach((btn) => {
    btn.addEventListener("click", () => {
      document.querySelectorAll(".filter").forEach((b) => b.classList.remove("active"));
      btn.classList.add("active");
      activeFilter = btn.dataset.filter;
      renderMilestones();
    });
  });
}

function showFeedback(msg) {
  el.rescueFeedback.textContent = msg;
}

function renderAll() {
  updateDailyNicotineHistory();
  const quitMs = getQuitDateMs();
  const nowMs = getNow();
  const elapsedMs = getElapsedMs();
  const totalXP = getTotalXP();
  const levelData = getLevelData(totalXP);

  el.levelValue.textContent = String(levelData.level);
  el.levelRing.style.setProperty("--progress", String(levelData.progress));
  if (quitMs > nowMs) {
    el.timeClean.textContent = `T-${formatDuration(quitMs - nowMs)}`;
  } else {
    el.timeClean.textContent = formatDuration(elapsedMs);
  }
  el.xpText.textContent = `${totalXP} XP • ${levelData.xpToNext} to next`;
  el.trustScore.textContent = `Trust ${getTrustScore()}`;

  el.moneySaved.textContent = formatMoney(getMoneySaved());
  el.nrtSpent.textContent = formatMoney(getNRTSpent());
  el.netSavings.textContent = formatMoney(getMoneySaved() - getNRTSpent());
  el.nicotineToday.textContent = `${getCurrentNicotineMg().toFixed(1)} mg`;
  el.nicotineReduction.textContent = `${Math.round(getNicotineReductionPct())}%`;
  if (el.nrtQuickSummary) {
    const dayTotals = getNRTLogTotalsForDay();
    const todayLogCount = (state.nrtLogs || []).filter((log) => getLogDayKey(log) === getTodayKey()).length;
    el.nrtQuickSummary.textContent = `Today: ${dayTotals.nicotine.toFixed(1)} mg logged • ${formatMoney(dayTotals.cost)} spent • ${todayLogCount} log${todayLogCount === 1 ? "" : "s"}.`;
  }
  if (el.nrtConfigNote) {
    const product = NRT_PRODUCTS.includes(state.nrtSelectedProduct) ? state.nrtSelectedProduct : "gum";
    const cfg = getNRTConfig(product);
    const unitCost = Math.max(0, Number(cfg.packCost || 0)) / Math.max(1, Number(cfg.unitsPerPack || 1));
    const effective = getCurrentNicotineEquivalentMg();
    const baseline = getBaselineNicotineMg();
    el.nrtConfigNote.textContent = `Today from logs: ${getCurrentNicotineMg().toFixed(1)} mg raw (${effective.toFixed(1)} mg effective) • ${formatMoney(getNRTDailyCost())}. Baseline from smoking/vaping: ${baseline.toFixed(1)} mg/day. ${getNRTProductLabel(product)} config: ${cfg.mgPerUnit} mg/unit, ${formatMoney(unitCost)}/unit.`;
  }
  el.cigsAvoided.textContent = Math.floor(getCigsAvoided()).toLocaleString();
  el.cravingsResisted.textContent = state.cravingsResisted.toLocaleString();
  el.shieldCount.textContent = `${state.streakShields} (+${state.shieldFragments}/3)`;

  renderNextUnlock();
  renderQuests();
  renderMilestones();
  renderQuickPatchActions();
  renderCustomPatchList();
  renderNRTLogList();
  renderNicotineTrendChart();

  saveState();
}

function renderNextUnlock() {
  const next = getNextMilestone();
  if (!next) {
    el.nextUnlockEta.textContent = "Legend";
    el.nextUnlockTitle.textContent = "All seeded milestones unlocked";
    el.nextUnlockDesc.textContent = "Keep stacking resilience and personal goals.";
    return;
  }

  el.nextUnlockEta.textContent = milestoneEtaLabel(next);
  el.nextUnlockTitle.textContent = next.title;
  el.nextUnlockDesc.textContent = next.desc;
}

function renderQuests() {
  const day = getTodayKey();
  const record = state.dailyRecords[day];
  const quests = getTodayQuests();

  el.questList.innerHTML = "";

  quests.forEach((quest) => {
    const done = Boolean(record?.completed?.[quest.id]);
    const li = document.createElement("li");
    li.className = `quest-item${done ? " done" : ""}`;

    li.innerHTML = `
      <div>
        <p class="quest-title">${quest.title}</p>
        <p class="quest-sub">${quest.subtitle} • +${quest.xp} XP</p>
      </div>
      <button class="${done ? "secondary-btn" : "primary-btn"}" data-quest-id="${quest.id}" ${done ? "disabled" : ""}>
        ${done ? "Done" : "Complete"}
      </button>
    `;

    el.questList.appendChild(li);
  });

  el.questCount.textContent = `${getQuestCompletedCount()}/3`;
}

function renderMilestones() {
  const all = getAllMilestones();
  const filtered = all.filter((m) => activeFilter === "all" || m.type === activeFilter);

  filtered.sort((a, b) => getMilestoneSortValue(a) - getMilestoneSortValue(b));

  el.milestoneList.innerHTML = "";

  filtered.forEach((m) => {
    const unlocked = isMilestoneUnlocked(m);
    const claimed = isMilestoneClaimed(m.id);
    const skipped = isMilestoneSkipped(m.id);
    const card = document.createElement("article");
    card.className = `mile${claimed ? " unlocked" : unlocked ? " unlocked" : ""}`;

    const meta = [];
    if (typeof m.hoursUntilQuitMax === "number") meta.push(`T-${formatShortHoursWindow(m.hoursUntilQuitMax)}`);
    if (typeof m.hours === "number") {
      if (m.hours < 1) meta.push(`${Math.round(m.hours * 60)}m`);
      else if (m.hours < 24) meta.push(`${Math.round(m.hours)}h`);
      else meta.push(`${Math.round(m.hours / 24)}d`);
    }
    if (typeof m.reductionPct === "number") meta.push(`${m.reductionPct}% target`);
    if (typeof m.targetNicotineMg === "number") meta.push(`<= ${m.targetNicotineMg.toFixed(1)} mg/day`);
    if (typeof m.amount === "number") meta.push(formatMoney(m.amount));
    if (typeof m.count === "number") meta.push(`${m.count} wins`);
    if (typeof m.evidence === "string" && m.evidence) meta.push(`evidence: ${m.evidence}`);

    card.innerHTML = `
      <div class="mile-head">
        <p class="mile-title">${m.title}</p>
        <span class="pill">${
          claimed
            ? "Unlocked"
            : unlocked
              ? skipped ? "Skipped" : "Ready"
              : milestoneEtaLabel(m)
        }</span>
      </div>
      <p class="mile-meta">${m.type.toUpperCase()} • ${meta.join(" • ")} • +${m.xp} XP</p>
      <p class="mile-desc">${m.desc}</p>
      ${
        unlocked && !claimed
          ? `<button class="primary-btn" data-unlock-id="${m.id}" style="margin-top:8px;">Unlock</button>`
          : ""
      }
    `;

    el.milestoneList.appendChild(card);
  });
}
