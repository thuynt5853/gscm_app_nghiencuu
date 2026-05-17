using System;
using System.Collections.Generic;
using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System.IO;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Web;
using BL.GSTP.GDTTT;
using System.Text;
using BL.GSTP.Quantri;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.QUANTRI;

namespace WEB.GSTP.HDSD
{
    //public partial class HDSD : System.Web.UI.Page
    //{
    //    GSTPContext dt = new GSTPContext();
    //    CultureInfo cul = new CultureInfo("vi-VN");
    //    private const decimal ROOT = 0;
    //    protected void Page_Load(object sender, EventArgs e)
    //    {
    //        if (!IsPostBack)
    //        {
    //            Session["MaChuongTrinh"] = "HDSD_APP";
    //            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
    //            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
    //            DM_DATAITEM oCD = new DM_DATAITEM();
    //            decimal chucdanh_id = 0;
    //            if (oCB != null)
    //            {
    //                chucdanh_id = (string.IsNullOrEmpty(oCB.CHUCDANHID + "")) ? 0 : Convert.ToDecimal(oCB.CHUCDANHID);
    //                oCD = dt.DM_DATAITEM.Where(x => x.ID == chucdanh_id).FirstOrDefault();
    //            }
    //            //////////-----------
    //            String pb = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
    //            String Ma_HT = Session["MA_HDSD"] + "";
    //            if (Ma_HT != "")
    //            {
    //                switch (Ma_HT)
    //                {
    //                    case "GSTP":
    //                        break;
    //                    case "QLA":
    //                        iframe_pub.Src = "/UI/pdfjs/web/viewer.html?file=%2FHDSD/HDSD_STPT.pdf";
    //                        break;
    //                    case "GDT":
    //                        if (oCD.MA == "TPTATC")
    //                        {
    //                            iframe_pub.Src = "/UI/pdfjs/web/viewer.html?file=%2FHDSD/HDSD_GDTTT_TP.pdf";
    //                        }
    //                        else
    //                        {
    //                            if (pb == "2" || pb == "3" || pb == "4" || pb == "14" || pb == "15" || pb == "16")
    //                            {
    //                                iframe_pub.Src = "/UI/pdfjs/web/viewer.html?file=%2FHDSD/HDSD_GDTTT.pdf";
    //                            }
    //                            else if (pb == "1" || pb == "4" || pb == "13")
    //                            {
    //                            }
    //                        }
    //                        break;
    //                    case "TDKT":
    //                        break;
    //                    case "TCCB":
    //                        break;
    //                    case "QTHT":
    //                        break;
    //                }
    //            }
    //            else
    //            {
    //                string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";
    //                QT_NGUOIDUNG_BL oBL = new QT_NGUOIDUNG_BL();
    //                decimal USERID = Convert.ToDecimal(strUserID);
    //                DataTable lstHT;
    //                string strSessionKeyHT = "HETHONGGETBY_" + USERID.ToString();
    //                if (Session[strSessionKeyHT] == null)
    //                    lstHT = oBL.QT_HETHONG_GETBYUSER(USERID);
    //                else
    //                    lstHT = (DataTable)Session[strSessionKeyHT];

    //                if (lstHT.Rows.Count > 0)
    //                {
    //                    foreach (DataRow r in lstHT.Rows)
    //                    {
    //                        switch (r["MA"] + "")
    //                        {
    //                            case "GSTP":
    //                                break;
    //                            case "QLA":
    //                                iframe_pub.Src = "/UI/pdfjs/web/viewer.html?file=%2FHDSD/HDSD_STPT.pdf";
    //                                break;
    //                            case "GDT":
    //                                if (oCD.MA == "TPTATC")
    //                                {
    //                                    iframe_pub.Src = "/UI/pdfjs/web/viewer.html?file=%2FHDSD/HDSD_GDTTT_TP.pdf";
    //                                }
    //                                else
    //                                {
    //                                    if (pb == "2" || pb == "3" || pb == "4" || pb == "14" || pb == "15" || pb == "16")
    //                                    {
    //                                        iframe_pub.Src = "/UI/pdfjs/web/viewer.html?file=%2FHDSD/HDSD_GDTTT.pdf";
    //                                    }
    //                                    else if (pb == "1" || pb == "4"|| pb == "13")
    //                                    {
    //                                    }
    //                                }
    //                                break;
    //                            case "TDKT":
    //                                break;
    //                            case "TCCB":
    //                                break;
    //                            case "QTHT":
    //                                break;
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
    //    // DownLoad("~/HDSD/HDSD_GDTTT_TP.pdf");
    //    public void DownLoad(string Path)
    //    {
    //        string filePath = Server.MapPath(Path);
    //        System.IO.FileInfo file = new System.IO.FileInfo(filePath);
    //        if (file.Exists)
    //        {
    //            FileStream fileStream = File.OpenRead(filePath);
    //            MemoryStream memStream = new MemoryStream();
    //            memStream.SetLength(file.Length);
    //            fileStream.Read(memStream.GetBuffer(), 0, (int)fileStream.Length);
    //            Response.Clear();
    //            Response.ContentType = "application/pdf";
    //            //Response.ContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
    //            Response.AddHeader("Content-Disposition", "attachment; filename=" + file.Name.Replace(" ", "_").Trim());
    //            Response.BinaryWrite(memStream.ToArray());
    //            Response.Flush();
    //            Response.Close();
    //            Response.End();
    //        }
    //    }
    //}
    public partial class HDSD : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //pnDgFile.Visible = false;
                LoadFile();
            }
        }
        protected void cmdThemFileTL_Click(object sender, EventArgs e)
        {
            try
            {
                if (hddFilePath.Value != "")
                {
                    string strFilePath = hddFilePath.Value.Replace("/", "\\");
                    var txtTen = System.IO.Path.GetFileName(strFilePath);
                    QT_FILE_BL fileHelper = new QT_FILE_BL();
                    var qtFile = fileHelper.InsertFile_Minio_Banan(strFilePath, 11, "HDSD");
                    if (qtFile == null)
                    {
                        lbthongbao.Text = "Lỗi khi lưu file!";
                        return;
                    }
                    DM_HDSD oTF = new DM_HDSD();
                    oTF.FILE_NAME = qtFile.FILE_NAME;
                    oTF.FILE_URL = qtFile.FILE_URL;
                    oTF.FILE_TYPE = qtFile.FILE_TYPE;
                    oTF.NGUOI_SUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oTF.DATE_CREATED = qtFile.DATE_CREATED;
                    oTF.STATE = 0;
                    oTF.QT_FILE_ID = qtFile.ID;
                    DataExtensions.Insert<DM_HDSD>(oTF);
                    File.Delete(strFilePath);
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi khi lưu file! " + ex.ToString();
                return;
            }
            LoadFile();
        }
        private void LoadFile()
        {
            var oT = DataExtensions.GetAllWithClause<DM_HDSD>("STATE != 1");
            dgFile.DataSource = oT.ToList();
            dgFile.DataBind();
            foreach (DataGridItem item in dgFile.Items)
            {
                LinkButton lbtXoa = (LinkButton)item.FindControl("lbtXoa");
                if ((Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" == "1"))
                {
                    pnZonekythuong.Visible = true;
                    lbtXoa.Visible = true;
                }
                else
                {
                    pnZonekythuong.Visible = false;
                    lbtXoa.Visible = false;
                }
            }
        }
        protected void dgFile_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    DM_HDSD oT = DataExtensions.FindById<DM_HDSD>(ND_id);
                    if (oT.QT_FILE_ID != null)
                    {
                        QT_FILE qtFileDelete = DataExtensions.FindById<QT_FILE>(oT.QT_FILE_ID.Value);
                        if (qtFileDelete != null)
                        {
                            qtFileDelete.DESCRIPTION = "Tài khoản " + Session[ENUM_SESSION.SESSION_USERNAME] + " đã xóa file!";
                            QT_FILE_BL fileH = new QT_FILE_BL();
                            fileH.DeleteFileLogic(qtFileDelete);
                        }
                    }
                    DataExtensions.Delete(oT);
                    LoadFile();
                    break;
                case "Download":
                    DM_HDSD oND = DataExtensions.FindById<DM_HDSD>(ND_id);
                    QT_FILE qT_FILE = DataExtensions.FindById<QT_FILE>(oND.QT_FILE_ID.Value);
                    // Xây dựng path cho file
                    string _pathStore = QT_FILE_BL.ToPathFolderStore(qT_FILE.DATE_CREATED.Value, 11) + "\\HDSD";
                    string fileNameWithoutExtension = Path.GetFileNameWithoutExtension(qT_FILE.FILE_NAME);
                    string pathRaw = Path.Combine(_pathStore,
                        Cls_Comon.ChuyenTVKhongDau(fileNameWithoutExtension) +
                        qT_FILE.ID +
                        qT_FILE.FILE_TYPE);
                    var pathUrlStyle = pathRaw.Replace("\\", "/");
                    var encodedPath = HttpUtility.UrlEncode(pathUrlStyle);
                    // Đảm bảo HTTPS
                    var authority = Request.Url.GetLeftPart(UriPartial.Authority).Replace(System.Configuration.ConfigurationManager.AppSettings["http"], System.Configuration.ConfigurationManager.AppSettings["https"]);
                    var appPath = Request.ApplicationPath?.TrimEnd('/') ?? "";
                    string downloadUrl = $"{authority}{appPath}/Quantri/Cauhinh/FileDownload.ashx?p={HttpUtility.UrlEncode(encodedPath)}";

                    // JavaScript redirect
                    string script = $@"window.location.href = '{downloadUrl}';";

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "downloadScript", script, true);
                    break;
            }

        }
        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            try
            {
                //if (AsyncFileUpLoad.HasFile && dgFile.Items.Count < 1)
                //{
                    string extension = Path.GetExtension(Request.Files[0].FileName).ToLower();
                    if (extension == ".doc" || extension == ".docx" || extension == ".pdf")
                    {
                        string strFileName = AsyncFileUpLoad.FileName;
                        string path = Server.MapPath("~/TempUpload/") + strFileName;
                        AsyncFileUpLoad.SaveAs(path);
                        path = path.Replace("\\", "/");
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
                    }
                    else lbthongbao.Text = "chỉ lưu file .doc ";
                //}
                //else lbthongbao.Text = "Chỉ được chọn 1 file.";
            }
            catch (Exception ex) { lbthongbao.Text = "Lỗi: " + ex.Message; }
        }
    }
}