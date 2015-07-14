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
    public partial class cambiarContrasenia : Form
    {
        int user;
        public cambiarContrasenia(int us)
        {
            user = us;
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            String pasword1 = textBox1.Text;
            String pasword2 = textBox2.Text;
           
            if (pasword2 != pasword1)
            {
                MessageBox.Show("no coinciden nuevas contraseñas");
                new cambiarContrasenia(user).Show();
                this.Close();
                return;

            }
            System.Data.SqlClient.SqlCommand comando=Coneccion.getComando();
            comando.CommandText = "execute NMI.nuevaContraseña " + username + ",'"  + pasword1 + "'";
            try
            {
                comando.ExecuteNonQuery();
                MessageBox.Show("Contraseña actualizada");
            }
            catch (System.Data.SqlClient.SqlException er) { MessageBox.Show(er.Message); }
        }
        }
    }
}
