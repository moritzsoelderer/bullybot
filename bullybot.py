from dotenv import load_dotenv
import discord
from discord.ext import commands
import os
from insults import insult

load_dotenv()

intents = discord.Intents.default()
intents.message_content = True
bot = commands.Bot(command_prefix='!', intents=intents)

@bot.event
async def on_ready():
    print(f'{bot.user} has connected to Discord!')
    print(f'Bot is in {len(bot.guilds)} servers')

@bot.command(name='bully')
async def bully(ctx, member: discord.Member):
    await ctx.send(f'{ctx.author.mention} requested bullying {member.name}')
    await ctx.send(insult(member.name))
    
if __name__ == "__main__":
    TOKEN = os.getenv('DISCORD_BOT_TOKEN')
    if TOKEN:
        bot.run(TOKEN)
    else:
        print("Please set DISCORD_BOT_TOKEN environment variable")