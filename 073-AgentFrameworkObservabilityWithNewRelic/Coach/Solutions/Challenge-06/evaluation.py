"""
TravelPlanEvaluator - Complete Implementation for Challenge-06

This module provides comprehensive evaluation capabilities for AI-generated travel plans,
including rule-based checks, LLM-based quality assessment, and metrics tracking.
"""

import os
import json
import asyncio
import logging
import re
from datetime import datetime
from typing import Optional
from dataclasses import dataclass, field, asdict

from agent_framework import ChatAgent
from agent_framework.openai import OpenAIChatClient
from agent_framework.observability import get_tracer, get_meter

# Configure logging
logger = logging.getLogger("travel_planner.evaluation")

# Get tracer and meter for observability
tracer = get_tracer()
meter = get_meter()

# ============================================================================
# Metrics for Evaluation Tracking
# ============================================================================

evaluation_passed_counter = meter.create_counter(
    name="travel_plan.evaluation.passed",
    description="Count of evaluations that passed all checks",
    unit="1"
)

evaluation_failed_counter = meter.create_counter(
    name="travel_plan.evaluation.failed",
    description="Count of evaluations that failed one or more checks",
    unit="1"
)

evaluation_score_histogram = meter.create_histogram(
    name="travel_plan.evaluation.score",
    description="Distribution of evaluation scores (0-100)",
    unit="1"
)

rule_check_counter = meter.create_counter(
    name="travel_plan.evaluation.rule_checks",
    description="Count of rule-based evaluation checks performed",
    unit="1"
)

llm_evaluation_counter = meter.create_counter(
    name="travel_plan.evaluation.llm_checks",
    description="Count of LLM-based evaluation checks performed",
    unit="1"
)

evaluation_duration_histogram = meter.create_histogram(
    name="travel_plan.evaluation.duration_ms",
    description="Time taken to evaluate travel plans",
    unit="ms"
)


# ============================================================================
# Data Classes for Structured Results
# ============================================================================

@dataclass
class RuleBasedResult:
    """Result from rule-based evaluation."""
    score: int
    passed: bool
    issues: list[str] = field(default_factory=list)
    checks_performed: int = 0

    def to_dict(self) -> dict:
        return asdict(self)


@dataclass
class LLMBasedResult:
    """Result from LLM-based evaluation."""
    toxicity_score: int = 10  # 0=toxic, 10=clean
    negativity_score: int = 10  # 0=negative, 10=positive
    safety_score: int = 10  # 0=unsafe, 10=safe
    accuracy_score: int = 10  # 0=inaccurate, 10=accurate
    completeness_score: int = 10  # 0=incomplete, 10=complete
    overall_score: int = 10
    issues: list[str] = field(default_factory=list)
    passed: bool = True
    recommendation: str = "APPROVE"  # APPROVE, REVIEW, REJECT
    raw_response: str = ""

    def to_dict(self) -> dict:
        return asdict(self)


@dataclass
class EvaluationResult:
    """Combined evaluation result."""
    rule_based: RuleBasedResult
    llm_based: Optional[LLMBasedResult]
    overall_passed: bool
    overall_score: float
    evaluation_time_ms: float
    destination: str
    timestamp: str = field(default_factory=lambda: datetime.now().isoformat())

    def to_dict(self) -> dict:
        return {
            "rule_based": self.rule_based.to_dict(),
            "llm_based": self.llm_based.to_dict() if self.llm_based else None,
            "overall_passed": self.overall_passed,
            "overall_score": self.overall_score,
            "evaluation_time_ms": self.evaluation_time_ms,
            "destination": self.destination,
            "timestamp": self.timestamp
        }


# ============================================================================
# TravelPlanEvaluator Class
# ============================================================================

class TravelPlanEvaluator:
    """
    Evaluates generated travel plans for quality, safety, and tone.

    This evaluator combines:
    1. Rule-based checks (fast, deterministic)
    2. LLM-based analysis (thorough, semantic)
    3. Metrics tracking (for monitoring)

    Usage:
        evaluator = TravelPlanEvaluator()
        result = await evaluator.evaluate(travel_plan_text, "Barcelona")

        if result.overall_passed:
            # Serve the plan to the user
        else:
            # Handle failed evaluation
    """

    # Configurable thresholds
    MIN_WORD_COUNT = 100
    MAX_WORD_COUNT = 2000
    MIN_RULE_SCORE = 70
    MIN_LLM_SCORE = 6  # Out of 10

    # Required sections for a complete travel plan
    REQUIRED_KEYWORDS = [
        "day 1",
        "weather",
    ]

    # Optional but recommended keywords (lower penalty)
    RECOMMENDED_KEYWORDS = [
        "accommodation",
        "transportation",
        "restaurant",
        "tip",
        "budget",
    ]

    # Dangerous destinations to flag
    UNSAFE_DESTINATIONS = [
        "war zone",
        "active conflict",
        "travel warning",
        "do not travel",
        "level 4",
    ]

    def __init__(
        self,
        enable_llm_evaluation: bool = True,
        model_id: str = "gpt-5-mini",
        strict_mode: bool = False
    ):
        """
        Initialize the TravelPlanEvaluator.

        Args:
            enable_llm_evaluation: Whether to use LLM for quality checks
            model_id: The model to use for LLM evaluation
            strict_mode: If True, require all checks to pass
        """
        self.enable_llm_evaluation = enable_llm_evaluation
        self.strict_mode = strict_mode
        self.model_id = model_id

        # Initialize LLM evaluator if enabled
        if enable_llm_evaluation:
            self._init_evaluator_agent(model_id)
        else:
            self.evaluator_agent = None

        logger.info(
            f"TravelPlanEvaluator initialized (LLM={enable_llm_evaluation}, model={model_id})")

    def _init_evaluator_agent(self, model_id: str):
        """Initialize the LLM agent for evaluation."""

        # Try GitHub Models first, fall back to OpenAI
        api_key = os.environ.get(
            "GITHUB_TOKEN") or os.environ.get("OPENAI_API_KEY")
        base_url = os.environ.get("GITHUB_ENDPOINT", None)

        if not api_key:
            logger.warning(
                "No API key found for LLM evaluation - disabling LLM checks")
            self.evaluator_agent = None
            self.enable_llm_evaluation = False
            return

        client_kwargs = {
            "api_key": api_key,
            "model_id": model_id
        }
        if base_url:
            client_kwargs["base_url"] = base_url

        self.evaluator_agent = ChatAgent(
            chat_client=OpenAIChatClient(**client_kwargs),
            instructions="""You are a quality assurance expert evaluating AI-generated travel plans.

Your job is to analyze travel plan responses for potential issues across these dimensions:

1. **Toxicity** (0-10, 10=clean): Check for offensive, rude, discriminatory, or harmful language.
2. **Negativity** (0-10, 10=positive): Check if the tone is unnecessarily negative, discouraging, or pessimistic.
3. **Safety** (0-10, 10=safe): Check if recommendations are safe - no war zones, dangerous conditions, extreme weather warnings without proper advisories.
4. **Accuracy** (0-10, 10=accurate): Check if destinations, activities, and recommendations are plausible and real.
5. **Completeness** (0-10, 10=complete): Check if the plan addresses the user's requirements with sufficient detail.

You MUST respond with ONLY a valid JSON object. No explanations, no markdown, just JSON.

Example response format:
{"toxicity_score": 10, "negativity_score": 9, "safety_score": 10, "accuracy_score": 8, "completeness_score": 9, "overall_score": 9, "issues": [], "pass": true, "recommendation": "APPROVE"}"""
        )

    def rule_based_evaluation(self, response: str) -> RuleBasedResult:
        """
        Check the travel plan against business rules.

        This is fast, deterministic, and catches obvious issues.

        Args:
            response: The generated travel plan text

        Returns:
            RuleBasedResult with score, pass/fail, and issues
        """
        with tracer.start_as_current_span("evaluation.rule_based") as span:
            score = 100
            issues = []
            checks = 0

            response_lower = response.lower()

            # Rule 1: Check for day-by-day structure
            checks += 1
            day_pattern = r'\bday\s*\d+\b|\bday\s+one\b|\bday\s+two\b|\bday\s+three\b'
            if not re.search(day_pattern, response_lower):
                issues.append(
                    "No day-by-day structure found (missing 'Day 1', 'Day 2', etc.)")
                score -= 30
                span.set_attribute("check.day_structure", False)
            else:
                span.set_attribute("check.day_structure", True)

            # Rule 2: Check for weather information
            checks += 1
            if "weather" not in response_lower and "temperature" not in response_lower:
                issues.append("Weather information missing")
                score -= 20
                span.set_attribute("check.weather", False)
            else:
                span.set_attribute("check.weather", True)

            # Rule 3: Response length sanity check
            checks += 1
            words = len(response.split())
            span.set_attribute("response.word_count", words)

            if words < self.MIN_WORD_COUNT:
                issues.append(
                    f"Response too short ({words} words, minimum {self.MIN_WORD_COUNT})")
                score -= 25
                span.set_attribute("check.length", "too_short")
            elif words > self.MAX_WORD_COUNT:
                issues.append(
                    f"Response too long ({words} words, maximum {self.MAX_WORD_COUNT})")
                score -= 10
                span.set_attribute("check.length", "too_long")
            else:
                span.set_attribute("check.length", "ok")

            # Rule 4: Check for required keywords
            for keyword in self.REQUIRED_KEYWORDS:
                checks += 1
                if keyword.lower() not in response_lower:
                    issues.append(f"Missing required content: {keyword}")
                    score -= 15

            # Rule 5: Check for recommended keywords (smaller penalty)
            missing_recommended = []
            for keyword in self.RECOMMENDED_KEYWORDS:
                checks += 1
                if keyword.lower() not in response_lower:
                    missing_recommended.append(keyword)
                    score -= 5

            if missing_recommended:
                issues.append(
                    f"Missing recommended content: {', '.join(missing_recommended)}")

            # Rule 6: Check for unsafe destination mentions
            checks += 1
            unsafe_found = [
                kw for kw in self.UNSAFE_DESTINATIONS if kw in response_lower]
            if unsafe_found:
                issues.append(
                    f"Potential safety concerns detected: {', '.join(unsafe_found)}")
                score -= 40
                span.set_attribute("check.safety_keywords", False)
            else:
                span.set_attribute("check.safety_keywords", True)

            # Rule 7: Check for contact information (shouldn't have personal data)
            checks += 1
            phone_pattern = r'\b\d{3}[-.]?\d{3}[-.]?\d{4}\b'
            email_pattern = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'

            if re.search(phone_pattern, response) or re.search(email_pattern, response):
                issues.append(
                    "Response contains potential personal contact information")
                score -= 20

            # Ensure score doesn't go below 0
            score = max(0, score)
            passed = score >= self.MIN_RULE_SCORE

            # Record metrics
            rule_check_counter.add(checks, {"type": "rule_based"})

            span.set_attribute("evaluation.score", score)
            span.set_attribute("evaluation.passed", passed)
            span.set_attribute("evaluation.issues_count", len(issues))

            logger.info(f"Rule-based evaluation complete", extra={
                "score": score,
                "passed": passed,
                "issues": issues,
                "checks_performed": checks
            })

            return RuleBasedResult(
                score=score,
                passed=passed,
                issues=issues,
                checks_performed=checks
            )

    async def llm_based_evaluation(
        self,
        response: str,
        destination: str
    ) -> LLMBasedResult:
        """
        Use LLM to check for toxicity, negativity, safety issues.

        This is slower but catches semantic issues that rules can't.

        Args:
            response: The generated travel plan text
            destination: The destination being planned for

        Returns:
            LLMBasedResult with detailed scores and issues
        """
        if not self.enable_llm_evaluation or not self.evaluator_agent:
            return LLMBasedResult(
                passed=True,
                issues=["LLM evaluation disabled"],
                recommendation="SKIPPED"
            )

        with tracer.start_as_current_span("evaluation.llm_based") as span:
            span.set_attribute("destination", destination)
            span.set_attribute("model_id", self.model_id)

            # Truncate response if too long for evaluation
            max_chars = 4000
            truncated_response = response[:max_chars] + \
                "..." if len(response) > max_chars else response

            eval_prompt = f"""Evaluate this travel plan for {destination}:

---
{truncated_response}
---

Analyze for toxicity, negativity, safety concerns, accuracy, and completeness.

Return ONLY this JSON structure:
{{
    "toxicity_score": <0-10>,
    "negativity_score": <0-10>,
    "safety_score": <0-10>,
    "accuracy_score": <0-10>,
    "completeness_score": <0-10>,
    "overall_score": <0-10>,
    "issues": [<list of specific concerns, empty if none>],
    "pass": <true/false>,
    "recommendation": "<APPROVE|REVIEW|REJECT>"
}}"""

            try:
                eval_response = await self.evaluator_agent.run(eval_prompt)
                eval_text = eval_response.messages[-1].contents[0].text.strip()

                # Try to extract JSON from the response
                # Handle potential markdown code blocks
                if "```json" in eval_text:
                    eval_text = eval_text.split(
                        "```json")[1].split("```")[0].strip()
                elif "```" in eval_text:
                    eval_text = eval_text.split(
                        "```")[1].split("```")[0].strip()

                result_dict = json.loads(eval_text)

                # Record metrics
                llm_evaluation_counter.add(
                    1, {"model": self.model_id, "status": "success"})

                span.set_attribute("evaluation.overall_score",
                                   result_dict.get("overall_score", 0))
                span.set_attribute("evaluation.passed",
                                   result_dict.get("pass", False))

                return LLMBasedResult(
                    toxicity_score=result_dict.get("toxicity_score", 10),
                    negativity_score=result_dict.get("negativity_score", 10),
                    safety_score=result_dict.get("safety_score", 10),
                    accuracy_score=result_dict.get("accuracy_score", 10),
                    completeness_score=result_dict.get(
                        "completeness_score", 10),
                    overall_score=result_dict.get("overall_score", 10),
                    issues=result_dict.get("issues", []),
                    passed=result_dict.get("pass", True),
                    recommendation=result_dict.get(
                        "recommendation", "APPROVE"),
                    raw_response=eval_text
                )

            except json.JSONDecodeError as e:
                logger.error(f"Failed to parse LLM evaluation response: {e}")
                llm_evaluation_counter.add(
                    1, {"model": self.model_id, "status": "parse_error"})
                span.set_attribute("error", str(e))

                return LLMBasedResult(
                    passed=False,
                    issues=[f"Evaluation parse error: {str(e)}"],
                    recommendation="REVIEW",
                    raw_response=eval_text if 'eval_text' in locals() else ""
                )

            except Exception as e:
                logger.error(f"LLM evaluation failed: {e}")
                llm_evaluation_counter.add(
                    1, {"model": self.model_id, "status": "error"})
                span.set_attribute("error", str(e))

                return LLMBasedResult(
                    passed=False,
                    issues=[f"Evaluation error: {str(e)}"],
                    recommendation="REVIEW"
                )

    async def evaluate(
        self,
        response: str,
        destination: str,
        skip_llm: bool = False
    ) -> EvaluationResult:
        """
        Run full evaluation pipeline.

        Combines rule-based and LLM-based evaluation to provide
        comprehensive quality assessment.

        Args:
            response: The generated travel plan text
            destination: The destination being planned for
            skip_llm: If True, skip LLM evaluation (faster)

        Returns:
            EvaluationResult with all scores and pass/fail status
        """
        start_time = datetime.now()

        with tracer.start_as_current_span("evaluation.full") as span:
            span.set_attribute("destination", destination)
            span.set_attribute("skip_llm", skip_llm)
            span.set_attribute("response_length", len(response))

            # Step 1: Rule-based evaluation (always run)
            rule_results = self.rule_based_evaluation(response)

            # Step 2: LLM-based evaluation (if enabled)
            llm_results = None
            if not skip_llm and self.enable_llm_evaluation:
                llm_results = await self.llm_based_evaluation(response, destination)

            # Step 3: Calculate overall result
            if llm_results and llm_results.recommendation != "SKIPPED":
                # Combine scores: 60% rule-based, 40% LLM-based
                overall_score = (rule_results.score * 0.6) + \
                    (llm_results.overall_score * 10 * 0.4)

                if self.strict_mode:
                    # Both must pass
                    overall_passed = rule_results.passed and llm_results.passed
                else:
                    # Either can pass, but warn if LLM flags issues
                    overall_passed = rule_results.passed and (
                        llm_results.passed or llm_results.recommendation == "REVIEW"
                    )
            else:
                # Only rule-based
                overall_score = float(rule_results.score)
                overall_passed = rule_results.passed

            # Calculate duration
            duration_ms = (datetime.now() - start_time).total_seconds() * 1000

            # Record metrics
            evaluation_duration_histogram.record(duration_ms)

            if overall_passed:
                evaluation_passed_counter.add(1, {"destination": destination})
            else:
                evaluation_failed_counter.add(1, {"destination": destination})

            evaluation_score_histogram.record(overall_score)

            # Set span attributes
            span.set_attribute("evaluation.overall_passed", overall_passed)
            span.set_attribute("evaluation.overall_score", overall_score)
            span.set_attribute("evaluation.duration_ms", duration_ms)

            result = EvaluationResult(
                rule_based=rule_results,
                llm_based=llm_results,
                overall_passed=overall_passed,
                overall_score=overall_score,
                evaluation_time_ms=duration_ms,
                destination=destination
            )

            logger.info("Evaluation complete", extra={
                "destination": destination,
                "overall_passed": overall_passed,
                "overall_score": overall_score,
                "duration_ms": duration_ms,
                "rule_issues": rule_results.issues,
                "llm_issues": llm_results.issues if llm_results else []
            })

            return result

    def evaluate_sync(
        self,
        response: str,
        destination: str,
        skip_llm: bool = False
    ) -> EvaluationResult:
        """
        Synchronous wrapper for evaluate().

        Use this in non-async contexts like Flask routes.

        Args:
            response: The generated travel plan text
            destination: The destination being planned for
            skip_llm: If True, skip LLM evaluation (faster)

        Returns:
            EvaluationResult with all scores and pass/fail status
        """
        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
        try:
            return loop.run_until_complete(
                self.evaluate(response, destination, skip_llm)
            )
        finally:
            loop.close()


# ============================================================================
# TravelPlanMetrics - Track Quality Over Time
# ============================================================================

class TravelPlanMetrics:
    """
    Track quality metrics of generated travel plans over time.

    This enables data-driven evaluation by collecting real user feedback
    and historical quality trends.
    """

    def __init__(self, datafile: str = "evaluation_metrics.jsonl"):
        """
        Initialize metrics tracker.

        Args:
            datafile: Path to JSONL file for storing metrics
        """
        self.datafile = datafile

    def record(
        self,
        destination: str,
        response: str,
        evaluation_result: EvaluationResult,
        user_rating: Optional[int] = None,
        user_feedback: Optional[str] = None
    ):
        """
        Record a travel plan evaluation with optional user feedback.

        Args:
            destination: The destination that was planned
            response: The generated travel plan
            evaluation_result: The evaluation result
            user_rating: Optional 1-5 rating from user
            user_feedback: Optional text feedback from user
        """
        metrics = {
            "timestamp": datetime.now().isoformat(),
            "destination": destination,
            "word_count": len(response.split()),
            "evaluation_passed": evaluation_result.overall_passed,
            "evaluation_score": evaluation_result.overall_score,
            "rule_based_score": evaluation_result.rule_based.score,
            "rule_based_issues": evaluation_result.rule_based.issues,
            "user_rating": user_rating,
            "user_feedback": user_feedback
        }

        if evaluation_result.llm_based:
            metrics.update({
                "llm_toxicity_score": evaluation_result.llm_based.toxicity_score,
                "llm_safety_score": evaluation_result.llm_based.safety_score,
                "llm_recommendation": evaluation_result.llm_based.recommendation
            })

        # Append to JSONL file
        try:
            with open(self.datafile, 'a') as f:
                f.write(json.dumps(metrics) + "\n")
        except Exception as e:
            logger.error(f"Failed to write metrics: {e}")

    def get_statistics(self, days: int = 7) -> dict:
        """
        Get aggregate statistics over the specified time period.

        Args:
            days: Number of days to analyze

        Returns:
            Dictionary with aggregate statistics
        """
        from datetime import timedelta

        cutoff = datetime.now() - timedelta(days=days)

        records = []
        try:
            with open(self.datafile, 'r') as f:
                for line in f:
                    record = json.loads(line)
                    record_time = datetime.fromisoformat(record["timestamp"])
                    if record_time >= cutoff:
                        records.append(record)
        except FileNotFoundError:
            return {"error": "No metrics file found", "total_evaluations": 0}
        except Exception as e:
            return {"error": str(e), "total_evaluations": 0}

        if not records:
            return {"total_evaluations": 0}

        # Calculate statistics
        total = len(records)
        passed = sum(1 for r in records if r.get("evaluation_passed", False))
        scores = [r.get("evaluation_score", 0) for r in records]
        ratings = [r.get("user_rating")
                   for r in records if r.get("user_rating")]

        return {
            "total_evaluations": total,
            "pass_rate": passed / total if total > 0 else 0,
            "average_score": sum(scores) / len(scores) if scores else 0,
            "min_score": min(scores) if scores else 0,
            "max_score": max(scores) if scores else 0,
            "average_user_rating": sum(ratings) / len(ratings) if ratings else None,
            "ratings_count": len(ratings),
            "period_days": days
        }


# ============================================================================
# Convenience Functions
# ============================================================================

def create_evaluator(
    enable_llm: bool = True,
    model_id: str = "gpt-5-mini",
    strict: bool = False
) -> TravelPlanEvaluator:
    """
    Factory function to create a TravelPlanEvaluator with common defaults.

    Args:
        enable_llm: Whether to enable LLM-based evaluation
        model_id: Model to use for LLM evaluation
        strict: Whether to use strict mode

    Returns:
        Configured TravelPlanEvaluator instance
    """
    return TravelPlanEvaluator(
        enable_llm_evaluation=enable_llm,
        model_id=model_id,
        strict_mode=strict
    )


async def quick_evaluate(response: str, destination: str) -> bool:
    """
    Quick evaluation using only rule-based checks.

    Use this for fast checks where LLM evaluation isn't needed.

    Args:
        response: The generated travel plan text
        destination: The destination being planned for

    Returns:
        True if passed, False otherwise
    """
    evaluator = TravelPlanEvaluator(enable_llm_evaluation=False)
    result = await evaluator.evaluate(response, destination)
    return result.overall_passed


# ============================================================================
# Example Usage
# ============================================================================

if __name__ == "__main__":
    # Example usage and testing

    sample_plan = """
    # Your 3-Day Barcelona Adventure
    
    ## Day 1: Gothic Quarter Exploration
    Arrive at Barcelona Airport and check into your accommodation in the Gothic Quarter.
    The weather in Barcelona is sunny with temperatures around 22°C - perfect for exploring!
    
    Morning: Walk through the narrow medieval streets of the Barri Gòtic
    Afternoon: Visit the stunning Barcelona Cathedral
    Evening: Enjoy tapas at a local restaurant - try the patatas bravas!
    
    ## Day 2: Gaudí's Masterpieces
    Today we explore the architectural wonders of Antoni Gaudí.
    
    Morning: Visit the incredible Sagrada Família (book tickets in advance!)
    Afternoon: Explore Park Güell with its colorful mosaics
    Evening: Stroll down La Rambla and grab dinner near the port
    
    ## Day 3: Beach and Culture
    Time for some relaxation and final sightseeing.
    
    Morning: Relax at Barceloneta Beach
    Afternoon: Visit the Picasso Museum
    Evening: Watch the Magic Fountain light show at Montjuïc
    
    ## Accommodation Recommendations
    - Budget: Generator Barcelona Hostel (€25-40/night)
    - Mid-range: Hotel Jazz (€100-150/night)
    - Luxury: Hotel Arts Barcelona (€300+/night)
    
    ## Transportation Tips
    - Get a T-Casual card for 10 metro/bus rides
    - The airport bus (Aerobus) costs €6.75 each way
    - Most attractions are walkable in the city center
    
    ## Budget Estimate
    - Budget traveler: €80-100/day
    - Mid-range: €150-200/day
    - Luxury: €400+/day
    
    Enjoy your trip to beautiful Barcelona! 🇪🇸
    """

    async def main():
        # Create evaluator
        evaluator = TravelPlanEvaluator(
            enable_llm_evaluation=False)  # Disable LLM for quick test

        # Run evaluation
        result = await evaluator.evaluate(sample_plan, "Barcelona")

        print("=" * 60)
        print("EVALUATION RESULTS")
        print("=" * 60)
        print(f"Overall Passed: {result.overall_passed}")
        print(f"Overall Score: {result.overall_score:.1f}/100")
        print(f"Evaluation Time: {result.evaluation_time_ms:.2f}ms")
        print()
        print("Rule-Based Results:")
        print(f"  Score: {result.rule_based.score}/100")
        print(f"  Passed: {result.rule_based.passed}")
        print(
            f"  Issues: {result.rule_based.issues if result.rule_based.issues else 'None'}")
        print()

        if result.llm_based:
            print("LLM-Based Results:")
            print(f"  Overall Score: {result.llm_based.overall_score}/10")
            print(f"  Toxicity: {result.llm_based.toxicity_score}/10")
            print(f"  Safety: {result.llm_based.safety_score}/10")
            print(f"  Recommendation: {result.llm_based.recommendation}")

    asyncio.run(main())
