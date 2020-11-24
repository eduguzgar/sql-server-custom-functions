using System;
using System.Collections;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Text.RegularExpressions;

public class CustomFunctions
{
    #region User Defined Functions

    [Microsoft.SqlServer.Server.SqlFunction]

    public static string GetNumbersString(SqlString str)
    {
        if (str.IsNull)
        {
            return null;
        }

        string a = str.ToString();
        string b = string.Empty;

        for (int i = 0; i < a.Length; i++)
        {
            if (Char.IsDigit(a[i]))
                b += a[i];
        }

        if (b.Length == 0)
        {
            return null;
        }

        return b;
    }

    [Microsoft.SqlServer.Server.SqlFunction]

    public static int? GetIntAfterString(SqlString str, SqlString patt)
    {
        if (str.IsNull || patt.IsNull)
        {
            return null;
        }

        string theString = str.ToString();
        string pattern = patt.ToString();

        if (!theString.Contains(pattern))
        {
            return null;
        }

        int index = theString.IndexOf(pattern, 0) + pattern.Length;
        theString = theString.Substring(index);

        if (theString[0] == ' ')
        {
            theString = theString.TrimStart();
        }
        Match m = Regex.Match(theString, @"^[-+]?\d+");

        if (!m.Success)
        {
            return null;
        }

        return Int32.Parse(m.Value);
    }

    [Microsoft.SqlServer.Server.SqlFunction]

    public static long? GetBigIntAfterString(SqlString str, SqlString patt)
    {
        if (str.IsNull || patt.IsNull)
        {
            return null;
        }

        string theString = str.ToString();
        string pattern = patt.ToString();

        if (!theString.Contains(pattern))
        {
            return null;
        }

        int index = theString.IndexOf(pattern, 0) + pattern.Length;
        theString = theString.Substring(index);

        if (theString[0] == ' ')
        {
            theString = theString.TrimStart();
        }
        Match m = Regex.Match(theString, @"^[-+]?\d+");

        if (!m.Success)
        {
            return null;
        }

        return Int64.Parse(m.Value);
    }

    [Microsoft.SqlServer.Server.SqlFunction]

    public static float? GetRealAfterString(SqlString str, SqlString patt)
    {
        if (str.IsNull || patt.IsNull)
        {
            return null;
        }

        string theString = str.ToString();
        string pattern = patt.ToString();

        if (!theString.Contains(pattern))
        {
            return null;
        }

        int index = theString.IndexOf(pattern, 0) + pattern.Length;
        theString = theString.Substring(index);

        if (theString[0] == ' ')
        {
            theString = theString.TrimStart();
        }
        Match m = Regex.Match(theString, @"^[+-]?([0-9]*[.])?[0-9]+");

        if (!m.Success)
        {
            return null;
        }

        return float.Parse(m.Value);
    }

    [Microsoft.SqlServer.Server.SqlFunction]

    public static double? GetFloatAfterString(SqlString str, SqlString patt)
    {
        if (str.IsNull || patt.IsNull)
        {
            return null;
        }

        string theString = str.ToString();
        string pattern = patt.ToString();

        if (!theString.Contains(pattern))
        {
            return null;
        }

        int index = theString.IndexOf(pattern, 0) + pattern.Length;
        theString = theString.Substring(index);

        if (theString[0] == ' ')
        {
            theString = theString.TrimStart();
        }

        Match m = Regex.Match(theString, @"^[+-]?([0-9]*[.])?[0-9]+");

        if (!m.Success)
        {
            return null;
        }

        return double.Parse(m.Value);
    }

    #endregion

    #region Table Valued Functions

    [SqlFunction(FillRowMethodName = "FillRow",
        TableDefinition = "id int, value nvarchar(4000)")]

    public static IEnumerable SplitString(
        [SqlFacet(MaxSize = -1)]
        SqlString str,
        [SqlFacet(MaxSize = 255)]
        SqlString delimiter)
    {
        if (str.IsNull || delimiter.IsNull)
        {
            return null;
        }

        string[] values = str.Value.Split(delimiter.Value.ToCharArray());
        ValuePair[] results = new ValuePair[values.Length];

        for (int i = 0; i < values.Length; i++)
        {
            results[i] = new ValuePair(i + 1, values[i]);
        }

        return results;
    }

    [SqlFunction(FillRowMethodName = "FillRow",
    TableDefinition = "id int, value nvarchar(4000)")]

    public static IEnumerable SplitStringNoReplaceLeft(
    [SqlFacet(MaxSize = -1)]
        SqlString str,
    [SqlFacet(MaxSize = 255)]
        SqlString delimiter)
    {
        if (str.IsNull || delimiter.IsNull)
        {
            return null;
        }

        string pattern = "(?=" + delimiter.Value + ")";
        string[] values = Regex.Split(str.Value, pattern);
        ValuePair[] results = new ValuePair[values.Length];

        for (int i = 0; i < values.Length; i++)
        {
            results[i] = new ValuePair(i + 1, values[i]);
        }

        return results;
    }

    [SqlFunction(FillRowMethodName = "FillRow",
    TableDefinition = "id int, value nvarchar(4000)")]

    public static IEnumerable SplitStringNoReplaceRight(
    [SqlFacet(MaxSize = -1)]
        SqlString str,
    [SqlFacet(MaxSize = 255)]
        SqlString delimiter)
    {
        if (str.IsNull || delimiter.IsNull)
        {
            return null;
        }

        string pattern = "(?<=" + delimiter.Value + ")";
        string[] values = Regex.Split(str.Value, pattern);
        ValuePair[] results = new ValuePair[values.Length];

        for (int i = 0; i < values.Length; i++)
        {
            results[i] = new ValuePair(i + 1, values[i]);
        }

        return results;
    }
    public static void FillRow(object row, out int id, out SqlString value)
    {
        ValuePair pair = (ValuePair)row;
        id = pair.ID;
        value = pair.Value;
    }
    public class ValuePair
    {
        public ValuePair(int id, string value)
        {
            this.ID = id;
            this.Value = value;
        }

        public int ID { get; private set; }
        public string Value { get; private set; }
    }

    #endregion
};