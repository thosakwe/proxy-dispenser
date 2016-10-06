int howManyProxies(num amount) {
  if (amount < 100)
    return (0.75 * amount).round();
  else if (amount >= 100 && amount < 325) {
    return (amount / 0.65).round();
  } else return (amount / 0.55).round();
}

double computeCost(num nProxies) {
  if (nProxies < 100)
    return nProxies * 0.75;
  else if(nProxies >= 100 && nProxies < 500) {
    return nProxies * 0.65;
  } else return nProxies * 0.55;
}