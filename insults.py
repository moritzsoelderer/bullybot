import random

INSULTS = [
    "{name} you are a smelly bastard.",
    "{name}! Your mother does not love you.",
    "You have sweaty palms {name}"
]

insult = lambda name:  random.choice(INSULTS).format(name=name)