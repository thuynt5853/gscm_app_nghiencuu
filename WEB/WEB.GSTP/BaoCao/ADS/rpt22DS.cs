using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.ADS
{
    public partial class rpt22DS : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt22DS()
        {
            InitializeComponent();
        }

        private void SubBand_TP_ThanhVien_BeforePrint(object sender, CancelEventArgs e)
        {
            if (Parameters["prmTP_ThanhVien"].Value + "" == "")
            {
                SubBand_TP_ThanhVien.Visible = false;
            }
        }

        private void SubBand_HTND_BeforePrint(object sender, CancelEventArgs e)
        {
            if (Parameters["prmHTND"].Value + "" == "")
            {
                SubBand_HTND.Visible = false;
            }
        }
    }
}
