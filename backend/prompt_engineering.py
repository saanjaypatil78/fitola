"""
Prompt Engineering Module
Advanced prompt engineering techniques for fitness AI interactions
Following best practices: Clear context, specific instructions, structured output
"""
from typing import Dict, Any, List, Optional
import json


class FitnessPromptEngine:
    """
    Prompt engineering for fitness-related AI interactions
    Uses proven techniques:
    - Clear role definition
    - Structured context
    - Specific instructions
    - Output format specification
    - Few-shot examples when needed
    """
    
    def __init__(self):
        self.system_role = """You are an expert AI fitness coach and nutritionist with deep knowledge in:
- Exercise science and biomechanics
- Nutrition and dietary planning
- Goal setting and motivation psychology
- Different body types and their specific needs
- Age-appropriate fitness strategies
- Injury prevention and safe training practices

You provide personalized, actionable, and safe advice tailored to each individual's profile."""
    
    def create_fitness_plan_prompt(
        self,
        user_context: Dict[str, Any],
        parameters: Dict[str, Any],
        history: List[Dict] = None
    ) -> str:
        """
        Create an enhanced prompt for fitness plan generation
        
        Prompt Engineering Techniques Applied:
        1. Clear role and expertise definition
        2. Structured user context
        3. Specific output format requirements
        4. Safety constraints
        5. Personalization factors
        """
        
        # Extract user data
        age = user_context.get("age", parameters.get("age", 30))
        age_group = user_context.get("age_group", parameters.get("age_group", "Adult"))
        weight = user_context.get("weight", parameters.get("weight", 70))
        height = user_context.get("height", parameters.get("height", 170))
        body_type = user_context.get("body_type", parameters.get("body_type", "Mesomorph"))
        goals = user_context.get("goals", parameters.get("goals", ["General Fitness"]))
        duration_days = parameters.get("duration_days", 30)
        experience_level = parameters.get("experience_level", "Intermediate")
        available_equipment = parameters.get("equipment", "Basic (Dumbbells, Resistance Bands)")
        limitations = parameters.get("limitations", "None")
        
        # Build context from history
        history_context = self._build_history_context(history)
        
        prompt = f"""{self.system_role}

## USER PROFILE
- Age: {age} years ({age_group})
- Physical Stats: {weight}kg, {height}cm
- Body Type: {body_type}
- Experience Level: {experience_level}
- Available Equipment: {available_equipment}
- Physical Limitations: {limitations}

## FITNESS GOALS
{self._format_list(goals if isinstance(goals, list) else [goals])}

## PLAN DURATION
{duration_days} days

{history_context}

## TASK
Create a comprehensive, personalized {duration_days}-day fitness plan that:

1. **Progression**: Start at appropriate intensity and progressively increase
2. **Safety First**: Consider age, limitations, and experience level
3. **Goal-Oriented**: Directly target the specified fitness goals
4. **Practical**: Use available equipment and realistic time commitments
5. **Recovery**: Include proper rest days and recovery guidance
6. **Variety**: Mix different training modalities to prevent boredom

## OUTPUT FORMAT
Please structure your response as follows:

### Overview
[Brief summary of the plan philosophy and expected outcomes]

### Weekly Breakdown
**Week 1-{duration_days//7}:**

**Day 1: [Focus Area]**
- Warm-up: [5-10 minutes]
- Main Workout:
  * Exercise 1: [Name] - [Sets] x [Reps] - [Rest] - [Notes]
  * Exercise 2: [Name] - [Sets] x [Reps] - [Rest] - [Notes]
  * Exercise 3: [Name] - [Sets] x [Reps] - [Rest] - [Notes]
- Cool-down: [5-10 minutes]
- Estimated Duration: [X minutes]

[Continue for all days]

### Recovery Days
[Specify active recovery activities]

### Progress Tracking
[Key metrics to track progress]

### Safety Reminders
[Important precautions specific to this user]

### Progression Guidelines
[How to advance when ready]

Remember: Safety and gradual progression are paramount. Include proper form cues and listen-to-your-body reminders."""

        return prompt
    
    def create_nutrition_plan_prompt(
        self,
        user_context: Dict[str, Any],
        parameters: Dict[str, Any],
        history: List[Dict] = None
    ) -> str:
        """
        Create an enhanced prompt for nutrition plan generation
        """
        age = user_context.get("age", parameters.get("age", 30))
        weight = user_context.get("weight", parameters.get("weight", 70))
        height = user_context.get("height", parameters.get("height", 170))
        goals = user_context.get("goals", parameters.get("goals", ["Weight Management"]))
        city = user_context.get("city", parameters.get("city", "General"))
        allergies = user_context.get("allergies", parameters.get("allergies", []))
        dietary_preference = parameters.get("dietary_preference", "No restrictions")
        duration_days = parameters.get("duration_days", 7)
        
        history_context = self._build_history_context(history)
        
        # Calculate BMR and recommended calories
        # Note: Using Mifflin-St Jeor formula for males. For females, subtract 161 instead of +5.
        # In production, add gender parameter for accurate calculations.
        bmr = 10 * weight + 6.25 * height - 5 * age + 5  # Mifflin-St Jeor for male (approx)
        tdee = int(bmr * 1.5)  # Moderate activity
        
        prompt = f"""{self.system_role}

## USER PROFILE
- Age: {age} years
- Physical Stats: {weight}kg, {height}cm
- Location: {city}
- Dietary Preference: {dietary_preference}
- Allergies/Restrictions: {self._format_list(allergies) if allergies else "None"}

## NUTRITIONAL GOALS
{self._format_list(goals if isinstance(goals, list) else [goals])}

## CALCULATED NEEDS
- Basal Metabolic Rate (BMR): ~{int(bmr)} kcal/day
- Total Daily Energy Expenditure (TDEE): ~{tdee} kcal/day
- Recommended Calorie Target: Adjust based on goals

{history_context}

## TASK
Create a {duration_days}-day personalized nutrition plan that:

1. **Goal-Aligned**: Support the specified nutritional goals
2. **Locally Sourced**: Use ingredients available in {city} when possible
3. **Balanced**: Include all macronutrients and micronutrients
4. **Practical**: Easy to prepare, realistic portions
5. **Allergy-Safe**: Strictly avoid {', '.join(allergies) if allergies else 'N/A'}
6. **Sustainable**: Not overly restrictive, enjoyable foods

## OUTPUT FORMAT

### Daily Calorie Target
[Specify based on goals: maintenance/deficit/surplus]

### Macronutrient Split
- Protein: [X]g ([Y]%)
- Carbohydrates: [X]g ([Y]%)
- Fats: [X]g ([Y]%)

### {duration_days}-Day Meal Plan

**Day 1**

🌅 **Breakfast** (Time: 7-9 AM)
- Meal: [Detailed description]
- Calories: ~[X] kcal
- Protein: [X]g | Carbs: [X]g | Fats: [X]g
- Prep time: [X] minutes

☀️ **Mid-Morning Snack** (Time: 10-11 AM)
- Snack: [Description]
- Calories: ~[X] kcal

🌤️ **Lunch** (Time: 12-2 PM)
- Meal: [Detailed description]
- Calories: ~[X] kcal
- Protein: [X]g | Carbs: [X]g | Fats: [X]g
- Prep time: [X] minutes

🌙 **Evening Snack** (Time: 4-5 PM)
- Snack: [Description]
- Calories: ~[X] kcal

🌃 **Dinner** (Time: 7-9 PM)
- Meal: [Detailed description]
- Calories: ~[X] kcal
- Protein: [X]g | Carbs: [X]g | Fats: [X]g
- Prep time: [X] minutes

**Daily Total:** ~[X] kcal

[Continue for all {duration_days} days]

### Hydration Guidelines
[Water intake recommendations]

### Meal Prep Tips
[Time-saving strategies]

### Supplement Recommendations (Optional)
[If beneficial for goals]

### Shopping List
[Organized by category for the week]

Remember: This plan should be flexible. Listen to your body and adjust portions as needed."""

        return prompt
    
    def create_chat_prompt(
        self,
        user_context: Dict[str, Any],
        message: str,
        history: List[Dict] = None
    ) -> str:
        """
        Create enhanced chat prompt with context awareness
        """
        history_context = self._build_history_context(history, limit=5)
        
        user_info = self._extract_user_summary(user_context)
        
        prompt = f"""{self.system_role}

## CURRENT USER
{user_info}

{history_context}

## USER MESSAGE
{message}

## INSTRUCTIONS
Provide a helpful, personalized response that:
1. Addresses the user's specific question or concern
2. Considers their fitness level, goals, and context
3. Offers actionable advice
4. Is encouraging and motivating
5. Includes safety reminders when relevant
6. Keeps responses concise yet comprehensive (2-4 paragraphs)

Be conversational, empathetic, and supportive. You're not just an AI - you're their dedicated fitness coach."""

        return prompt
    
    def create_goal_tracking_prompt(
        self,
        user_context: Dict[str, Any],
        parameters: Dict[str, Any],
        history: List[Dict] = None
    ) -> str:
        """
        Create prompt for goal tracking and progress analysis
        """
        current_progress = parameters.get("current_progress", {})
        goal = parameters.get("goal", "fitness improvement")
        time_elapsed = parameters.get("days_elapsed", 0)
        
        history_context = self._build_history_context(history)
        user_info = self._extract_user_summary(user_context)
        
        prompt = f"""{self.system_role}

## USER PROFILE
{user_info}

{history_context}

## GOAL BEING TRACKED
{goal}

## TIME ELAPSED
{time_elapsed} days

## CURRENT PROGRESS
{json.dumps(current_progress, indent=2)}

## TASK
Analyze the user's progress and provide:

1. **Progress Assessment**: How are they doing relative to their goal?
2. **Achievements**: Celebrate wins, big and small
3. **Areas for Improvement**: Constructive feedback
4. **Adjusted Recommendations**: Any changes to their plan based on progress
5. **Motivation Boost**: Encouraging words tailored to their journey
6. **Next Milestones**: Clear next targets to aim for

Keep the tone positive, data-driven, and action-oriented."""

        return prompt
    
    def create_motivation_prompt(
        self,
        user_context: Dict[str, Any],
        parameters: Dict[str, Any],
        history: List[Dict] = None
    ) -> str:
        """
        Create motivational prompt tailored to user's situation
        """
        situation = parameters.get("situation", "general")
        mood = parameters.get("mood", "neutral")
        
        history_context = self._build_history_context(history, limit=3)
        user_info = self._extract_user_summary(user_context)
        
        prompt = f"""{self.system_role}

## USER PROFILE
{user_info}

{history_context}

## CURRENT SITUATION
{situation}

## USER MOOD/STATE
{mood}

## TASK
Provide personalized motivational support that:

1. **Acknowledges** their current feelings or situation
2. **Reminds** them of their goals and why they started
3. **Reframes** challenges as opportunities
4. **Provides** specific, actionable next steps
5. **Inspires** with relevant wisdom or encouragement
6. **Reassures** that setbacks are part of the journey

Keep it genuine, personal, and powerful. This should feel like a pep talk from a coach who really knows and cares about them. Use specific details from their profile to make it personal.

Length: 2-3 paragraphs that pack an emotional punch."""

        return prompt
    
    # Helper methods
    
    def _build_history_context(self, history: List[Dict] = None, limit: int = 3) -> str:
        """Build context from user's interaction history"""
        if not history:
            return ""
        
        recent = history[-limit:] if len(history) > limit else history
        context_lines = ["## INTERACTION HISTORY (Recent Context)"]
        
        for idx, interaction in enumerate(recent, 1):
            workflow = interaction.get("workflow", "unknown")
            timestamp = interaction.get("timestamp", "unknown")
            context_lines.append(f"{idx}. [{timestamp}] {workflow}")
        
        return "\n".join(context_lines)
    
    def _extract_user_summary(self, user_context: Dict[str, Any]) -> str:
        """Extract key user information for context"""
        lines = []
        
        if "age" in user_context or "age_group" in user_context:
            age = user_context.get("age", "")
            age_group = user_context.get("age_group", "")
            lines.append(f"- Age: {age} ({age_group})" if age else f"- Age Group: {age_group}")
        
        if "weight" in user_context and "height" in user_context:
            lines.append(f"- Stats: {user_context['weight']}kg, {user_context['height']}cm")
        
        if "body_type" in user_context:
            lines.append(f"- Body Type: {user_context['body_type']}")
        
        if "goals" in user_context:
            goals = user_context["goals"]
            lines.append(f"- Goals: {self._format_list(goals if isinstance(goals, list) else [goals])}")
        
        return "\n".join(lines) if lines else "Limited profile information available"
    
    def _format_list(self, items: List[str]) -> str:
        """Format a list for better prompt readability"""
        if not items:
            return "None specified"
        return "\n".join([f"  • {item}" for item in items])
