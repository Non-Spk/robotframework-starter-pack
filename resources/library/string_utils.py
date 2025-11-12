import datetime
import re

def get_type_name(value):
    return type(value).__name__

def parse_date(value):
    # Ensure the input is a string and remove leading/trailing whitespace
    value = str(value).strip()

    # 1) Try parsing format: DD/MM/YYYY
    try:
        date = datetime.datetime.strptime(value, "%d/%m/%Y")
        today = datetime.datetime.today()
        if date.year > today.year:
            raise ValueError("Year is in the future")
        else:
            return date
    except:
        pass

    # 2) Try parsing format: YYYYMMDD
    try:
        date = datetime.datetime.strptime(value, "%Y%m%d")
        today = datetime.datetime.today()
        if date.year > today.year:
            raise ValueError("Year is in the future")
        else:
            return date
    except:
        pass

    # 3) Try parsing format: YYYY/MM/DD
    try:
        date = datetime.datetime.strptime(value, "%Y/%m/%d")
        today = datetime.datetime.today()
        if date.year > today.year:
            raise ValueError("Year is in the future")
        else:
            return date
    except:
        pass

    # 4) Try parsing 6-digit format: YYMMDD (Thai Buddhist Year assumed)
    #    Convert Thai year (BE) to Gregorian year (AD)
    if re.match(r"^\d{6}$", value):
        yy = int(value[0:2])
        mm = int(value[2:4])
        dd = int(value[4:6])
        year = yy + 2500 - 543  # Convert BE to AD
        return datetime.datetime(year, mm, dd)

    # 5) Try parsing format: DD/MM/YY  (Thai Buddhist Year assumed)
    #    Convert Thai year (BE) to Gregorian year (AD)
    if re.match(r"^\d{2}/\d{2}/\d{2}$", value):
        dd, mm, yy = map(int, value.split("/"))
        year = yy + 2500 - 543  # BE → AD
        return datetime.datetime(year, mm, dd)

    # Raise error if none of the formats match
    raise ValueError(f"Could not parse date: {value}")
