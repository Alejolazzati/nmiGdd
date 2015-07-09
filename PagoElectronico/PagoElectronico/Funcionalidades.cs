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
    public partial class Funcionalidades : Form
    {
        private int rolUsuario;
        public Funcionalidades(int rol)
        {
            InitializeComponent();
            rolUsuario = rol;
        }

        private void Funcionalidades_Load(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select * from funcionalidadesRol("+rolUsuario+")";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
                {
                    comboBox1.Items.Add(reader.GetSqlString(0));

                }
                this.Show();
            
            reader.Dispose();
        
        }
    }
}
