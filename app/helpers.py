def humanize(text):
    text = text.replace('_', ' ').title()
    return text

def remove_second_instance(lst):
    seen = set()
    return [x for i, x in enumerate(lst) if not (x in seen or seen.add(x))]
