using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.THA;
using Module.Common;
using BL.GSTP.Danhmuc;
using System.Globalization;
using System.Data;
using System.IO;


namespace WEB.GSTP.QLAN.THA.XoaAnTich
{
    public partial class PopupXoaAnTich : System.Web.UI.Page
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        GSTPContext dt = new GSTPContext();
        Decimal BiAnID = 0;

        THA_ANTICH_DON obj = new THA_ANTICH_DON();
        Decimal CurrUserID = 0;
        public string NgaySoSanh;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {
                    BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                    hddVuAnID.Value = Session[ENUM_LOAIAN.AN_HINHSU] + "" == "" ? "" : Session[ENUM_LOAIAN.AN_HINHSU] + "";
                    LoadNguoiKyDdlInfo();
                    load_infor();
                    CheckQuyen();
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }

        void CheckQuyen()
        {
            Boolean IsOk = true;
            try
            {
                THA_THULY obj = dt.THA_THULY.Where(x => x.BIANID == BiAnID).FirstOrDefault<THA_THULY>();
                if (obj != null)
                    NgaySoSanh = ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul);
                else
                {
                    lttMsg.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                    cmdUpdateVuAn.Visible = false;
                    IsOk = false;
                }
            }
            catch (Exception ex)
            {
                lttMsg.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                cmdUpdateVuAn.Visible = false;
                IsOk = false;
            }
            //-----------------------------
            if (!IsOk)
            {
                try
                {
                    THA_BIAN_QUYETDINH objQD = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiAnID).FirstOrDefault();
                    if (objQD != null)
                        NgaySoSanh = ((DateTime)objQD.NGAYTHIHANH).ToString("dd/MM/yyyy", cul);
                    else
                    {
                        lttMsg.Text = "Bị án chưa có quyết định thi hành án. Bạn hãy kiểm tra lại!";
                        cmdUpdateVuAn.Visible = false;
                        IsOk = false;
                    }
                }
                catch (Exception ex)
                {
                    lttMsg.Text = "Bị án chưa có quyết định thi hành án. Bạn hãy kiểm tra lại!";
                    cmdUpdateVuAn.Visible = false;
                    IsOk = false;
                }
            }
        }

        void load_infor()
        {
            pnCapCN.Visible = true;
            rdKetQua.SelectedValue = "0";
            txtSoCN.Text = "";
            hddNguoiKyID.Value = "0";
            txtNgayCN.Text = "";
            txtNoidung.Text = "";
            decimal THAID_VuAn = Convert.ToDecimal(Request.QueryString["IDVUAN"]);
            THA_VUAN objVuAn = dt.THA_VUAN.Where(x => x.ID == THAID_VuAn).FirstOrDefault();

            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            lbtDownload.Visible = false;
            if (objVuAn != null)
            {
                THA_ANTICH_DON TM = dt.THA_ANTICH_DON.Where(x => x.VUANID == objVuAn.ID).FirstOrDefault();
                rdYeuCau_XoaAn.SelectedValue = "1";
                if (TM != null)
                {
                    THA_ANTICH_FILE oFile = dt.THA_ANTICH_FILE.Where(x => x.ANTICH_DON_ID == TM.ID).FirstOrDefault();

                    if (TM.KETQUA != null)
                    {
                        cmdSua.Visible = true;
                        cmdXoa.Visible = true;
                        cmdUpdateVuAn.Visible = false;
                    }
                    else
                    {
                        cmdSua.Visible = false;
                        cmdXoa.Visible = false;
                        cmdUpdateVuAn.Visible = true;
                    }


                    if (oFile != null && TM.KETQUA == 0)
                    {
                        lbtDownload.Visible = true;
                        hddFileID.Value = TM.ID.ToString();
                    }
                    else
                    {
                        lbtDownload.Visible = false;
                        hddFileID.Value = "0";
                    }
                    if (!String.IsNullOrEmpty(TM.KETQUA + ""))
                        rdKetQua.SelectedValue = TM.KETQUA + "";
                    if (TM.KETQUA == 0)
                    {
                        pnCapCN.Visible = true;
                        txtSoCN.Text = TM.SOCN;
                        hddNguoiKyID.Value = TM.IDNGUOIKY.ToString();
                        ddlNguoiky.SelectedValue = TM.IDNGUOIKY.ToString();
                        txtNgayCN.Text = string.IsNullOrEmpty(TM.NGAYCN + "") ? "" : ((DateTime)TM.NGAYCN).ToString("dd/MM/yyyy", cul);
                        txtNoidung.Text = TM.NOIDUNG;
                    }
                    if (TM.KETQUA == 1)
                    {
                        pnCapCN.Visible = false;
                        txtSoCN.Text = "";
                        hddNguoiKyID.Value = "0";
                        txtNgayCN.Text = "";
                        txtNoidung.Text = "";
                    }
                }

            }

        }

        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            decimal THAID_VuAn = Convert.ToDecimal(Request.QueryString["IDVUAN"]);
            THA_VUAN objVuAn = dt.THA_VUAN.Where(x => x.ID == THAID_VuAn).FirstOrDefault();
            if (objVuAn != null)
            {
                THA_ANTICH_DON obj = dt.THA_ANTICH_DON.Where(x => x.VUANID == objVuAn.ID).FirstOrDefault();
                if (obj != null)
                {
                    THA_ANTICH_FILE oAnTichFile = new THA_ANTICH_FILE();
                    THA_ANTICH_FILE oAnTichFileCheck = dt.THA_ANTICH_FILE.Where(x => x.ANTICH_DON_ID == obj.ID).FirstOrDefault();
                    if (oAnTichFileCheck != null)
                    {
                        oAnTichFile = oAnTichFileCheck;
                    }
                    obj.KETQUA = Convert.ToDecimal(rdKetQua.SelectedValue);
                    obj.SOCN = txtSoCN.Text;
                    obj.NGAYCN = (String.IsNullOrEmpty(txtNgayCN.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayCN.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.IDNGUOIKY = Convert.ToDecimal(ddlNguoiky.SelectedValue);
                    obj.NOIDUNG = txtNoidung.Text;
                    dt.SaveChanges();
                    if (rdKetQua.SelectedValue == "0" && hddFilePath.Value != "")
                    {
                        try
                        {
                            string strFilePath = hddFilePath.Value.Replace("/", "\\");
                            byte[] buff = null;
                            using (FileStream fs = File.OpenRead(strFilePath))
                            {
                                BinaryReader br = new BinaryReader(fs);
                                FileInfo oF = new FileInfo(strFilePath);
                                long numBytes = oF.Length;
                                buff = br.ReadBytes((int)numBytes);
                                oAnTichFile.NOIDUNGFILE = buff;
                                oAnTichFile.TENFILE = Cls_Comon.ChuyenTVKhongDau(oF.Name);
                                oAnTichFile.KIEUFILE = oF.Extension;
                                oAnTichFile.ANTICH_DON_ID = obj.ID;
                                if (oAnTichFileCheck != null)
                                {
                                    dt.SaveChanges();
                                }
                                else
                                {
                                    dt.THA_ANTICH_FILE.Add(oAnTichFile);
                                    dt.SaveChanges();
                                }

                                lbtDownload.Visible = true;
                            }
                        }
                        catch (Exception ex) { lbthongbao.Text = ex.Message; }
                    }
                    hddFileID.Value = obj.ID.ToString();

                    lbthongbao.Text = "Cập nhật thành công!";
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                    cmdSua.Visible = true;
                    cmdXoa.Visible = true;
                    cmdUpdateVuAn.Visible = false;
                }
            }
        }

        protected void cmdSua_Click(object sender, EventArgs e)
        {
            cmdSua.Visible = false;
            cmdUpdateVuAn.Visible = true;
        }

        protected void cmdXoa_Click(object sender, EventArgs e)
        {
            decimal THAID_VuAn = Convert.ToDecimal(Request.QueryString["IDVUAN"]);
            THA_VUAN objVuAn = dt.THA_VUAN.Where(x => x.ID == THAID_VuAn).FirstOrDefault();
            if (objVuAn != null)
            {
                THA_ANTICH_DON obj = dt.THA_ANTICH_DON.Where(x => x.VUANID == objVuAn.ID).FirstOrDefault();
                THA_ANTICH_FILE objFile = dt.THA_ANTICH_FILE.Where(x => x.ANTICH_DON_ID == obj.ID).FirstOrDefault();
                if (objFile != null)
                {
                    dt.THA_ANTICH_FILE.Remove(objFile);
                }
                if (obj != null)
                {
                    obj.KETQUA = null;
                    dt.SaveChanges();

                }
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                lbthongbao.Text = "Xóa thành công!";
                cmdSua.Visible = false;
                cmdUpdateVuAn.Visible = true;
                cmdXoa.Visible = false;
                pnCapCN.Visible = true;
                rdKetQua.SelectedValue = "0";
                txtSoCN.Text = "";
                hddNguoiKyID.Value = "0";
                txtNgayCN.Text = "";
                txtNoidung.Text = "";
                lbtDownload.Visible = false;
            }

        }

        protected void rdKetQua_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdKetQua.SelectedValue == "0")
            {
                pnCapCN.Visible = true;
            }
            else
            {
                pnCapCN.Visible = false;
            }
        }

        protected void lbtDownload_Click(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddFileID.Value);
            THA_ANTICH_FILE oFile = dt.THA_ANTICH_FILE.Where(x => x.ANTICH_DON_ID == ID).FirstOrDefault();
            if (oFile.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oFile.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oFile.TENFILE + "&Extension=" + oFile.KIEUFILE + "';", true);
            }

        }

        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoad.HasFile)
            {
                string strFileName = AsyncFileUpLoad.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoad.SaveAs(path);

                path = path.Replace("\\", "/");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
            }
        }

        private void LoadNguoiKyDdlInfo()
        {
            decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value); ;

            DataTable tbl = null;
            decimal CanBoID = 0;
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();

            //--------------------------------------            
            //Lấy danh sách Chánh án, phó chánh án
            tbl = cb_BL.DM_CANBO_GETBYDONVI_2CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA);
            //Lấy chủ tọa vụ án
            AHS_SOTHAM_HDXX oND = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).FirstOrDefault<AHS_SOTHAM_HDXX>();
            if (oND != null)
            {
                CanBoID = Convert.ToDecimal(oND.CANBOID.ToString());
                DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                if (dtCanBo.Rows.Count > 0)
                {
                    DataRow dr = tbl.NewRow();
                    dr["MA_TEN"] = dtCanBo.Rows[0]["HOTEN"].ToString() + "-Thẩm phán chủ tọa";
                    dr["ID"] = dtCanBo.Rows[0]["ID"].ToString();
                    tbl.Rows.Add(dr);
                }
            }
            else
            {
                AHS_THAMPHANGIAIQUYET oTP = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).FirstOrDefault();
                if (oTP != null)
                {
                    ddlNguoiky.DataSource = tbl;

                    CanBoID = Convert.ToDecimal(oTP.CANBOID.ToString());
                    DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                    if (dtCanBo.Rows.Count > 0)
                    {
                        DataRow dr = tbl.NewRow();
                        dr["MA_TEN"] = dtCanBo.Rows[0]["HOTEN"].ToString() + "-Thẩm phán chủ tọa";
                        dr["ID"] = dtCanBo.Rows[0]["ID"].ToString();
                        tbl.Rows.Add(dr);
                    }
                }
            }
            ddlNguoiky.DataSource = tbl;
            ddlNguoiky.DataTextField = "MA_TEN";
            ddlNguoiky.DataValueField = "ID";
            ddlNguoiky.DataBind();
            if (CanBoID > 0)
                ddlNguoiky.SelectedValue = CanBoID.ToString();
            hddNguoiKyID.Value = ddlNguoiky.SelectedValue;

        }
    }
}