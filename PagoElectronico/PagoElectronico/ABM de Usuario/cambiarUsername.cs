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
    public partial class cambiarUsername : Form
    {
        int usuario;
        public cambiarUsername(int codUser)
        {
            InitializeComponent();
            usuario = codUser;
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "select useranme from NMI.Usuario where id_usuario=" + codUser;
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            reader.Read();
            textBox1.Text=reader.GetValue(0).ToString();
            reader.Dispose();
        }

        private void cambiarUsername_Load(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Update NMI.Usuario set useranme = '"+textBox1.Text+"' where id_usuario=" + usuario;
            try { comando.ExecuteNonQuery(); MessageBox.Show("Cambio exitoso"); this.Close(); }
            catch (System.Data.SqlClient.SqlException er) { MessageBox.Show(er.Message); }
        }
    }
}
