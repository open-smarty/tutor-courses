"""
Module 6, Lesson 2 — Big Data SQC: EWMA and CUSUM (Solution)
"""
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(42)
mu0, sigma, n_obs = 100.0, 5.0, 150
shift_at, shift_size = 50, 3.0

in_control = np.random.normal(mu0, sigma, shift_at)
shifted    = np.random.normal(mu0 + shift_size, sigma, n_obs - shift_at)
data = np.concatenate([in_control, shifted])

lam, L = 0.2, 3.0
ewma = np.zeros(n_obs)
ewma[0] = data[0]
for i in range(1, n_obs):
    ewma[i] = lam * data[i] + (1 - lam) * ewma[i-1]

ewma_ucl = mu0 + L * sigma * np.sqrt(lam / (2 - lam))
ewma_lcl = mu0 - L * sigma * np.sqrt(lam / (2 - lam))

K = shift_size / 2
H = 4.0 * sigma
c_plus  = np.zeros(n_obs)
c_minus = np.zeros(n_obs)
for i in range(1, n_obs):
    c_plus[i]  = max(0, c_plus[i-1]  + (data[i] - mu0 - K))
    c_minus[i] = max(0, c_minus[i-1] - (data[i] - mu0 + K))

ewma_signals  = np.where((ewma > ewma_ucl) | (ewma < ewma_lcl))[0]
cusum_signals = np.where((c_plus > H) | (c_minus > H))[0]

ewma_detection  = ewma_signals[0]  + 1 if len(ewma_signals)  > 0 else None
cusum_detection = cusum_signals[0] + 1 if len(cusum_signals) > 0 else None

print("=== Detection Comparison ===")
print(f"Shift injected at observation:  {shift_at} (mean shifts from {mu0} to {mu0+shift_size})")
print(f"EWMA  detected shift at obs:    {ewma_detection}  (+{ewma_detection-shift_at if ewma_detection else '?'} obs after shift)")
print(f"CUSUM detected shift at obs:    {cusum_detection}  (+{cusum_detection-shift_at if cusum_detection else '?'} obs after shift)")

fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 8))
obs = np.arange(1, n_obs + 1)

ax1.plot(obs, ewma, 'b-', linewidth=1.5, label='EWMA')
ax1.axhline(mu0,      color='green', linestyle='-', linewidth=1.5, label=f'CL={mu0}')
ax1.axhline(ewma_ucl, color='red',   linestyle='--', label=f'UCL={ewma_ucl:.1f}')
ax1.axhline(ewma_lcl, color='red',   linestyle='--', label=f'LCL={ewma_lcl:.1f}')
ax1.axvline(shift_at, color='orange', linestyle=':', linewidth=2, label=f'Shift at t={shift_at}')
if ewma_detection:
    ax1.axvline(ewma_detection, color='purple', linestyle='--', label=f'Detected t={ewma_detection}')
ax1.set_title(f'EWMA Chart (λ={lam}) — Detected at obs {ewma_detection}')
ax1.legend(fontsize=8)
ax1.grid(True, alpha=0.3)

ax2.plot(obs, c_plus,  'b-', linewidth=1.5, label='C⁺')
ax2.plot(obs, c_minus, 'r-', linewidth=1.5, label='C⁻')
ax2.axhline(H, color='red',   linestyle='--', label=f'H={H:.1f}')
ax2.axhline(0, color='green', linestyle='-',  linewidth=0.8)
ax2.axvline(shift_at, color='orange', linestyle=':', linewidth=2, label=f'Shift at t={shift_at}')
if cusum_detection:
    ax2.axvline(cusum_detection, color='purple', linestyle='--', label=f'Detected t={cusum_detection}')
ax2.set_title(f'CUSUM Chart (K={K:.1f}, H={H:.1f}) — Detected at obs {cusum_detection}')
ax2.legend(fontsize=8)
ax2.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('ewma_cusum_charts.png', dpi=100)
plt.show()
