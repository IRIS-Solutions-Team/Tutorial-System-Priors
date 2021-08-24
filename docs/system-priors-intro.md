# Intro to estimation and calibration using system priors

![[title-page]]


---

## Priors in bayesian estimation

* Traditionally, priors on individual parameters

* However, more often than not we simply wish to control the behavior of
  the model as a whole system...

* ...not so much the individual parameters

---

## Non-bayesian interpretation of priors

* Shrinkage (or penalty) function

* Keep the parameters close to our “preferred” values

* ”Close” is defined by the shape/curvature of the shrinkage/penalty function

* Example: Normal priors are equivalent to quadratic shrinkage/penalty

---

## Examples of system priors


* Model-implied correlation between output and inflation

* Model-implied sacrifice ratio

* Frequency response function from output to potential output (band of periodicities are passed into potential output)

* Suppress secondary cycles in shock responses (e.g. more than 90% of a shock response has to occur within the first 10 quarter)

* Anything


---

## Independent individual marginals



Posterior density

$$
p\left(\theta \mid Y, m \right) \propto p\left(Y \mid \theta, m\right)
\times p\left(\theta \mid m\right)
$$



Prior density typically consists of independent marginal priors

$$
p\left(\theta \mid m \right) =
p_1\left(\theta_1 \mid m \right)
\times
p_2\left(\theta_2 \mid m \right)
\times \cdots \times
p_n\left(\theta_n \mid m \right)
$$

Variance-bias trade-off

---

## Example: Normal independent individual marginals

Equivalent to "ridge regression"

<br/>

$$
\begin{gathered}
\max\nolimits_{\{\theta\}} \ 
\log p\left(Y \mid \theta, m\right)
+ \log p\left(\theta \mid m\right)
\\[15pt]
\equiv
\max\nolimits_{\{\theta\}} \log p\left(Y \mid \theta, m\right)
- \sum_{i=1}^n \left(\frac{\theta_i-\bar\theta_i}{\sigma} \right)^2
\end{gathered}
$$

---

## How to formalize system priors

Complement (or replace) with density involving a property of the model as a whole, $h\left(\theta\right)$

$$
p\left(\theta \mid m \right) =
p_1\left(\theta_1 \mid m \right)
\times \cdots \times
p_n\left(\theta_n \mid m \right)
\times
\color{red}{
q_1\bigl(h(\theta)\mid m\bigr)
\times \cdots \times
q_k\bigl(h(\theta)\mid m\bigr)
}
$$


---

## Benefits of System Priors in Estimation

* A relatively low number of system priors can push parameter estimates
  into a region where the properties of the model as a whole make sense and
  are well-behaved…

* …without enforcing a tighter prior structure on individual parameters


---

## Priors in calibration: Maximize prior mode

* Exclude/disregard data likelihood

* Only maximize prior mode


* Case 1: only independent priors on individual parameters
<br/>
$\Rightarrow$ modes of marginals

$$
p\left(\theta \mid m \right) =
p_1\left(\theta_1 \mid m \right)
\times \cdots \times
p_n\left(\theta_n \mid m \right)
\times \cdots
$$


* Case 2: only a small number of system priors
<br/>
$\Rightarrow$ very likely underdetermined (singular)

$$
p\left(\theta \mid m \right) = 
q_1\bigl(h(\theta)\mid m\bigr)
\times \cdots \times
q_k\bigl(h(\theta)\mid m\bigr)
$$


* Case 3: Combination of priors on individual parameters and system priors
<br/>
$\Rightarrow$ deviate as little as possible from the "preferred" values of
parameters while delivering sensible system properties
$$
p\left(\theta \mid m \right) =
p_1\left(\theta_1 \mid m \right)
\times \cdots \times
p_n\left(\theta_n \mid m \right)
\times
q_1\bigl(h(\theta)\mid m\bigr)
\times \cdots \times
q_k\bigl(h(\theta)\mid m\bigr)
$$


---

## Implemenation in IrisT

* Challenge: System priors are usually computationally intensive to evaluate

* The following `@Model` class functions (methods) can be used to construct a
`@SystemProperty` object for efficient evaluation of system properties

| Function | Description |
|---|---|
| `simulate` | Any kind of simulation, including complex simulation design |   
| `acf` | Autocovariance and autocorrelation functions |
| `xsf` | Power spectrum and spectral density functions |
| `ffrf` | Filter frequency response function |

* The `@SystemProperty` objects are then collected in a `@SystemPriorWrapper`
object, system prior densities are defined and the object is passed into
the `estimate` function.

---

## Practical advice

* Use lower/upper bounds

* Always eyeball the shape of the log density 

