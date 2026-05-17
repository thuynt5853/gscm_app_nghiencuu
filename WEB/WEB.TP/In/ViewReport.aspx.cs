using BL.GSTP;
using DAL.GSTP;
using Microsoft.Reporting.WebForms;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using DevExpress.XtraPrinting.Preview;
using System.Drawing.Printing;
using DevExpress.XtraReports.UI;
using DevExpress.XtraPrinting;
using DevExpress.XtraPrintingLinks;
using System.Drawing;
using System.IO;
using System.Windows.Forms;

namespace WEB.TP.In
{
    public partial class ViewReport : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                WEB.TP.In.TP_ANPHI oT = new TP_ANPHI();
                string strMaCT = Session["CHON_DATASET"] + "";
                switch (strMaCT)
                {
                    case "BIENLAI_DATASET":
                        idTitle.Text = "Biên lai án phí";
                        oT = (TP_ANPHI)Session["BIENLAI_DATASET"];
                        rptBienLaiAnPhi rptTKTBCQKN = new rptBienLaiAnPhi();
                        rptTKTBCQKN.DataSource = oT;
                        rptView.OpenReport(rptTKTBCQKN);
                      
                        break;
                    case "BIENLAIKYSO_DATASET":
                        idTitle.Text = "Ký số biên lai án phí";
                        oT = (TP_ANPHI)Session["BIENLAIKYSO_DATASET"];
                        rptBienLaiAnPhi rptKysoTKTBCQKN = new rptBienLaiAnPhi();
                        rptKysoTKTBCQKN.DataSource = oT;
                        rptView.OpenReport(rptKysoTKTBCQKN);


                        string maThongBao = oT.Tables[0].Rows[0]["MA_THONGBAO"].ToString();
                        // Chuyển đường dẫn lưu file PDF đã được chỉ định sẵn
                        string folder_upload = "/TempUpload/";
                        string fileName = maThongBao + ".pdf";
                        string pdfFilePath = Path.Combine(Server.MapPath(folder_upload), fileName);
                        rptKysoTKTBCQKN.CreateDocument();
                        rptKysoTKTBCQKN.ExportToPdf(pdfFilePath);

                        // Mở file PDF sau khi đã xuất
                        //System.Diagnostics.Process.Start(pdfFilePath);

                        rptView.ReportSourceId = null;
                        rptView.Visible = false;
                        this.Controls.Remove(rptView);

                        break;
                    case "ANPHI_DS_DATASET_CHUANOP":
                        idTitle.Text = "Danh sách";
                        oT = (TP_ANPHI)Session["ANPHI_DS_DATASET"];
                        rptDanhSach rptds = new rptDanhSach();
                        rptds.DataSource = oT;
                        rptView.OpenReport(rptds);
                        break;
                    case "ANPHI_DS_DATASET_DANOP":
                        idTitle.Text = "Danh sách";
                        oT = (TP_ANPHI)Session["ANPHI_DS_DATASET"];
                        rptDanhSachDaNop rptds_danop = new rptDanhSachDaNop();
                        rptds_danop.DataSource = oT;
                        rptView.OpenReport(rptds_danop);
                        break;
                    case "ANPHI_DS_HOANTRA":
                        idTitle.Text = "Danh sách";
                        oT = (TP_ANPHI)Session["ANPHI_DS_DATASET"];
                        rptDaNhanHoanTra_DS rptds_hoantra = new rptDaNhanHoanTra_DS();
                        rptds_hoantra.DataSource = oT;
                        rptView.OpenReport(rptds_hoantra);
                        break;
                    case "ANPHI_DS_TATCA":
                        idTitle.Text = "Danh sách";
                        oT = (TP_ANPHI)Session["ANPHI_DS_DATASET"];
                        rptTatCa_DS rptds_all = new rptTatCa_DS();
                        rptds_all.DataSource = oT;
                        rptView.OpenReport(rptds_all);
                        break;
                    case "ANPHI_DS_DATASET_DINHCHI":
                        idTitle.Text = "Danh sách";
                        oT = (TP_ANPHI)Session["ANPHI_DS_DATASET"];
                        rptDanhSach_DinhChi rptDINHCHI = new rptDanhSach_DinhChi();
                        rptDINHCHI.DataSource = oT;
                        rptView.OpenReport(rptDINHCHI);
                        break;
                }
            }
        }
    }
   
}