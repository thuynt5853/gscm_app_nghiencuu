using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.THA;
using Module.Common;
using BL.GSTP.Danhmuc;
using System.Globalization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;

namespace WEB.GSTP.QLAN.THA.XoaAnTich
{
    public partial class KetQua : System.Web.UI.Page
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
                    if (BiAnID > 0)
                    {
                        pn.Visible = true;
                        decimal current_idVuAn = 0;
                        current_idVuAn = (decimal)dt.THA_BIAN.Where(x => x.ID == BiAnID).FirstOrDefault().VUANID;
                        hddVuAnID.Value = current_idVuAn.ToString();
                        decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        LoadNguoiKyDdlInfo(ToaAnID);
                        load_infor();
                        CheckQuyen();
                    }
                    else
                    {
                        pn.Visible = false;
                        lbthongbao_top.Text = "Bạn cần chọn bị án để xử lý!";
                    }
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
                {
                    NgaySoSanh = ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul);
                    IsOk = false;
                }
                else
                {
                    lttMsg.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                    cmdUpdate.Visible = false;
                    IsOk = false;
                }
            }
            catch (Exception ex)
            {
                lttMsg.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                cmdUpdate.Visible = false;
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
                        cmdUpdate.Visible = false;
                        IsOk = false;
                    }
                }
                catch (Exception ex)
                {
                    lttMsg.Text = "Bị án chưa có quyết định thi hành án. Bạn hãy kiểm tra lại!";
                    cmdUpdate.Visible = false;
                    IsOk = false;
                }

                // Kiểm tra TOA_GIAIQUYET_ID
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                THA_BIAN_QUYETDINH objqd = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiAnID).FirstOrDefault();
                if (objqd != null)
                {
                    if (!string.IsNullOrEmpty(donviID) && objqd != null && objqd.TOA_GIAIQUYET_ID.HasValue)
                    {
                        if (objqd.TOA_GIAIQUYET_ID.ToString() != donviID)
                        {

                            cmdUpdate.Visible = false;
                            cmdSua.Visible = false;
                            cmdXoa.Visible = false;

                            lbthongbao.Text = "Đơn đã chuyển sang tòa khác, không thể chỉnh sửa.";
                        }
                    }
                }

            }

            THA_BIAN_BL objBL = new THA_BIAN_BL();
            string result = objBL.CHECK_THA_BIAN_DONGBO(BiAnID, 2);
            if (!string.IsNullOrEmpty(result))
            {
                lttMsg.Text = lbthongbao.Text = result;
                cmdUpdate.Visible = cmdSua.Visible = cmdXoa.Visible = false;
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
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_ANTICH_DON TM = dt.THA_ANTICH_DON.Where(x => x.BIANID == BiAnID).FirstOrDefault();
            //rdYeuCau_XoaAn.SelectedValue = "1"; 
            lbtDownload.Visible = false;
            if (TM != null)
            {
                if (TM.KETQUA != null)
                {
                    cmdSua.Visible = true;
                    cmdXoa.Visible = true;
                    cmdUpdate.Visible = false;
                }
                else
                {
                    cmdSua.Visible = false;
                    cmdXoa.Visible = false;
                    cmdUpdate.Visible = true;
                }


                THA_ANTICH_FILE oFile = dt.THA_ANTICH_FILE.Where(x => x.ANTICH_DON_ID == TM.ID).FirstOrDefault();
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
                    pnKhongCN.Visible = false;
                    txtSoCN.Text = TM.SOCN;
                    hddNguoiKyID.Value = TM.IDNGUOIKY.ToString();
                    ddlNguoiky.SelectedValue = TM.IDNGUOIKY.ToString();
                    txtNgayCN.Text = string.IsNullOrEmpty(TM.NGAYCN + "") ? "" : ((DateTime)TM.NGAYCN).ToString("dd/MM/yyyy", cul);
                    txtNoidung.Text = TM.NOIDUNG;
                }
                if (TM.KETQUA == 1)
                {
                    pnCapCN.Visible = false;
                    pnKhongCN.Visible = true;
                    txtSoCN.Text = "";
                    hddNguoiKyID.Value = "0";
                    txtNgayCN.Text = "";
                    txtNoidung.Text = "";

                    txtSoKCN.Text = TM.SOKHONGCHAPNHAN;
                    txtNgayKCN.Text = string.IsNullOrEmpty(TM.NGAYKHONGCHAPNHAN + "") ? "" : ((DateTime)TM.NGAYKHONGCHAPNHAN).ToString("dd/MM/yyyy", cul);
                }

                LoadNguoiKyDdlInfo(Convert.ToDecimal(TM.TOA_GIAIQUYET_ID.ToString()));

            }

        }

        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_ANTICH_DON obj = dt.THA_ANTICH_DON.Where(x => x.BIANID == BiAnID).FirstOrDefault();
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
                obj.SOKHONGCHAPNHAN = txtSoKCN.Text;
                obj.NGAYKHONGCHAPNHAN = (String.IsNullOrEmpty(txtNgayKCN.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayKCN.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
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
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                lbthongbao.Text = "Cập nhật thành công!";
                cmdSua.Visible = true;
                cmdXoa.Visible = true;
                cmdUpdate.Visible = false;
            }
        }

        protected void cmdSua_Click(object sender, EventArgs e)
        {
            cmdSua.Visible = false;
            cmdUpdate.Visible = true;
        }

        protected void cmdXoa_Click(object sender, EventArgs e)
        {
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_ANTICH_DON obj = dt.THA_ANTICH_DON.Where(x => x.BIANID == BiAnID).FirstOrDefault();
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
            cmdUpdate.Visible = true;
            cmdXoa.Visible = false;
            pnCapCN.Visible = true;
            rdKetQua.SelectedValue = "0";
            txtSoCN.Text = "";
            hddNguoiKyID.Value = "0";
            txtNgayCN.Text = "";
            txtNoidung.Text = "";
            lbtDownload.Visible = false;

        }

        protected void rdKetQua_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdKetQua.SelectedValue == "0")
            {
                pnCapCN.Visible = true;
                pnKhongCN.Visible = false;
            }
            else
            {
                pnCapCN.Visible = false;
                pnKhongCN.Visible = true;
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
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oFile.TENFILE + "&Extension=" + oFile.KIEUFILE + "';", true);
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

        private void LoadNguoiKyDdlInfo(decimal nguoiky)
        {
            decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value); ;

            DataTable tbl = null;
            decimal CanBoID = 0;
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();

            //--------------------------------------            
            //Lấy danh sách Chánh án, phó chánh án
            tbl = cb_BL.DM_CANBO_GETBYDONVI_2CHUCVU(nguoiky, ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA);
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