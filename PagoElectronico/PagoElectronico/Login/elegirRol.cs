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
            comboBox1.DropDownStyle = ComboBoxStyle.DropDownList;
        }

        private void elegirRol_Load(object sender, EventArgs e)
        {

        }

        public void llamar(string unNombre)
        {

            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select * from NMI.rolesUsuario('" + unNombre + "')";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            while (reader.Read())
            {
                comboBox1.Items.Add(reader.GetSqlString(0));

            }
            this.Show();
            reader.Dispose();

        }



        private void groupBox1_Enter(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            int rol;
            try
            {
                if (comboBox1.SelectedItem.ToString() == "Cliente")
                { rol = 1; }
                else { rol = 2; }

                Program.rol = rol;
                PagoElectronico.Login.Funcionalidades formFuncion = new PagoElectronico.Login.Funcionalidades();
                formFuncion.Show();
                this.Close();
                this.Hide();
            }

            catch (NullReferenceException er)
            {
                MessageBox.Show("Elija una opcion");


            }
        }
    }
}
