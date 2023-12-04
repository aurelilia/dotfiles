import datetime
import json

day = datetime.timedelta(1)
today = datetime.date.today()
monday = today
while monday.weekday() != 0:
    monday -= day

out = []
for i in range(0, 8):
    out.append({ 'day': monday.day, 'class': 'active' if monday == today else 'inactive' })
    monday += day

print(json.dumps(out))