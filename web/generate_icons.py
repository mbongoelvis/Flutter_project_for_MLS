"""Run once to generate placeholder app icons. Requires Pillow: pip install Pillow"""
from PIL import Image, ImageDraw
import os

os.makedirs('icons', exist_ok=True)

def make_icon(size, filename):
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    # Terracotta background circle
    draw.ellipse([0, 0, size, size], fill=(232, 99, 58, 255))
    # Simple "F" letter placeholder
    font_size = size // 2
    draw.text((size * 0.3, size * 0.2), 'F', fill='white')
    img.save(f'icons/{filename}')
    print(f'Generated icons/{filename}')

for s, name in [(192,'Icon-192.png'),(512,'Icon-512.png'),
                (192,'Icon-maskable-192.png'),(512,'Icon-maskable-512.png')]:
    make_icon(s, name)
