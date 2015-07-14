using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.ABM_de_Usuario
{
    public partial class modificarUsuario : Form
    {
        String username;
        int codUser;
        public modificarUsuario(String user)
        {   username=user;
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText="select Id_usuario from NMI.Usuario where useranme='"+user+"'"
            System.Data.SqlClient.SqlDataReader reader =comando.ExecuteReader();
            reader.Read();
            codUser=Int32.Parse(reader.GetValue(0).ToString());
            reader.Dispose();
            
            InitializeComponent();
        }

        private void modificarUsuario_Load(object sender, EventArgs e)
        {
            textBox1.Text = username;

        }
    }
}
