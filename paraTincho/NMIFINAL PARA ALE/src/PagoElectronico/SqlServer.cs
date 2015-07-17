using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PagoElectronico
{
    class SqlServer
    { private static System.Data.SqlClient.SqlConnection con=new System.Data.SqlClient.SqlConnection();

    public static System.Data.SqlClient.SqlConnection getInstance()
    {
        return con;
    }

    }
}
