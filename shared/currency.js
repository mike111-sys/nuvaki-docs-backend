// Determines display/payment currency from a user's country field.
// Rule:
//   - NULL / empty          -> KES (preserves existing users)
//   - 'Kenya' (any case)    -> KES
//   - anything else         -> USD
function resolveCurrency(country) {
 // shared/currency.js
// Rule:
//   - 'Kenya' (any case / KE / KEN) -> KES
//   - anything else (incl. NULL, '') -> USD
function resolveCurrency(country) {
  if (!country) return "USD";
  const c = String(country).trim().toLowerCase();
  if (c === "kenya" || c === "ke" || c === "ken") return "KES";
  return "USD";
}

function isKenya(country) {
  return resolveCurrency(country) === "KES";
}

module.exports = { resolveCurrency, isKenya };
  const c = String(country).trim().toLowerCase();
  if (c === "kenya" || c === "ke" || c === "ken") return "KES";
  return "USD";
}

function isKenya(country) {
  return resolveCurrency(country) === "KES";
}

module.exports = { resolveCurrency, isKenya };