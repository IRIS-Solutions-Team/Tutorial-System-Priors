# Estimation/Calibration Using System Priors

## Priors in Bayesian Estimation



* Traditionally, priors on individual parameters

* However, more often than not we simply wish to control the behavior of the model as a whole system, not so much the individual parameters…


---

##What Properties of the Model as a Whole? 



* Model-implied correlation between output and inflation

* Model-implied sacrifice ratio

* Frequency response function from output to potential output (band of periodicities are passed into potential output)

* Suppress secondary cycles in shock responses (e.g. more than 90% of a shock response has to occur within the first 10 quarter)

* Anything


---

## How to Technically Introduce System Priors



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

* A relatively low number of system priors can push parameter estimates into a region where the properties of the model as a whole make sense and are well-behaved…

* …without enforcing a tighter prior structure on individual parameters



---

## Non-Bayesian Interpretation of Priors

* Shrinkage (or penalty) function

* Keep the parameters close to our “preferred” values

* ”Close” is defined by the shape/curvature of the shrinkage/penalty function

* Example: Normal priors are equivalent to quadratic shrinkage/penalty


---

## Priors in Calibration: Maximize Prior Mode



$$
p\left(\theta \mid m \right) =
p_1\left(\theta_1 \mid m \right)
\times \cdots \times
p_n\left(\theta_n \mid m \right)
\times \cdots
$$

...rivial: modes of marginals



$$
p\left(\theta \mid m \right) = 
q_1\bigl(h(\theta)\mid m\bigr)
\times \cdots \times
q_k\bigl(h(\theta)\mid m\bigr)
$$

...nontrivial and very likely significantly underdetermined



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

...system priors combined with light (not very tight) individual priors





