using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.Login
{
    public partial class elegirRol : Form
    {
        public elegirRol()
        {
            InitializeComponent();
        }

        private void elegirRol_Load(object sender, EventArgs e)
        {

        }

        public void llamar(string unNombre, string unaPass)
        {
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select * from rolesUsuario("+unNombre+","+unaPass+")";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            if (!reader.Read()){
                MessageBox.Show("No coinciden user y pass");
            }

            while(reader.Read()){
                comboBox1.Items.Add(reader.GetSqlString(0));
               
            }

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }


    }
}
