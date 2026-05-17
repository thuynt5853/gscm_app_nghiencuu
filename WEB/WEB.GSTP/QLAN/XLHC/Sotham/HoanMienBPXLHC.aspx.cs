using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP.XLHC;
using NLog;

namespace WEB.GSTP.QLAN.XLHC.Sotham
{
    public partial class HoanMienBPXLHC : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    setTinhtrang(false);
                    txtNgaynhan.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    LoadDropBienPhapGQ();
                    decimal DONID = Session[ENUM_LOAIAN.BPXLHC] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
                    CheckQuyen(DONID);
                    LoadGrid_XuLyDon();
                    foreach (RepeaterItem item in rpt.Items)
                    {
                        LinkButton lblSua = (LinkButton)item.FindControl("lblSua");
                        LinkButton lbtXoa = (LinkButton)item.FindControl("lbtXoa");
                        if (hddShowCommand.Value == "False")
                        {
                            lblSua.Text = "Chi tiết";
                            lbtXoa.Visible = false;
                        }
                    }
                    //KiemTraDonXL();
                    ////check vụ án đã kết thúc không cho sửa xóa
                    //Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    //if (anKetThuc)
                    //{
                    //    lbtthongbao.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                    //    Cls_Comon.SetButton(cmdThemmoi, false);
                    //    Cls_Comon.SetButton(cmdCapNhat, false);

                    //}
                }
                catch (Exception ex)
                {
                    lbtthongbao.Text = ENUM_MESSAGE.SERVER_ERROR; ;
                    logger.Error("[toaanid={} donid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]), ex);
                }
            }
        }
        private void CheckQuyen(decimal DONID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdThemmoi, oPer.TAOMOI);
            Cls_Comon.SetButton(cmdCapNhat, oPer.CAPNHAT);

            List<XLHC_DON_THAMPHAN> lstCount = dt.XLHC_DON_THAMPHAN.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).ToList();
            if (lstCount.Count == 0)
            {
                lbtthongbao.Text = "Chưa phân công thẩm phán giải quyết đơn !";
                Cls_Comon.SetButton(cmdThemmoi, false);
                Cls_Comon.SetButton(cmdCapNhat, false);
                hddShowCommand.Value = "False";
                return;
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(DONID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbtthongbao.Text = Result;
                Cls_Comon.SetButton(cmdThemmoi, false);
                Cls_Comon.SetButton(cmdCapNhat, false);
                hddShowCommand.Value = "False";
                return;
            }
        }

        private bool coQuyenXoa(decimal idDonHoanMien)
        {
            //check thu ly
            XLHC_DON_HOANMIEN_BL xLHC_DON_HOANMIEN_BL = new XLHC_DON_HOANMIEN_BL();
            DataTable dataTable = xLHC_DON_HOANMIEN_BL.GET_DONXINHOANMIEN_THULY_BY_HOAN_MIEN_ID(idDonHoanMien);

            if (dataTable == null || dataTable.Rows.Count > 0)
            {
                lbtthongbao.Text = "Đã có thông tin thụ lý. Không thể xóa đơn!";
                return false;
            }

            XLHC_DON_HOANMIEN_BL xlhcDonHoanmienBl = new XLHC_DON_HOANMIEN_BL();
            DataTable table = xlhcDonHoanmienBl.GET_HOANMIEN_SOTHAM_HDXX_BY_DON_HOANMIEN(idDonHoanMien);

            if (table != null && table.Rows.Count > 0)
            {
                lbtthongbao.Text = "Đã có thông tin người tiến hành tố tụng . Không thể xóa đơn!";
                return false;
            }

            if (dt.XLHC_DONXIN_HOAN_MIEN.Where(x => x.ID == idDonHoanMien && x.DM_QUYETDINH_ID != null).Count() > 0)
            {
                lbtthongbao.Text = "Đã có kết quả giải quyết. Không thể xóa đơn!";
                return false;
            }

            return true;
        }

        protected void AsyncFileUpLoadHoanMien_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoadHoanMien.HasFile)
            {
                string strFileName = AsyncFileUpLoadHoanMien.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoadHoanMien.SaveAs(path);

                path = path.Replace("\\", "/");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath_KC.ClientID + "\").value = '" + path + "';", true);
            }
        }

        protected void lbtDownloadHoanMien_Click(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddCurrID.Value);
            XLHC_DONXIN_HOAN_MIEN oND = dt.XLHC_DONXIN_HOAN_MIEN.Where(x => x.ID == ID).FirstOrDefault();
            if (oND.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS_CONFIG() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
            }
        }

        protected void cmdLoad_Click(object sender, EventArgs e)
        {
            LoadGrid_XuLyDon();
            //decimal DONID = Session[ENUM_LOAIAN.AN_DANSU] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_DANSU] + "");
            //LoadDropDuongSu(DONID);
        }

        void LoadDropBienPhapGQ()
        {
            dropBienPhapGQ.Items.Clear();
            //dropBienPhapGQ.Items.Add(new ListItem("-------- Chọn --------",""));
            dropBienPhapGQ.Items.Add(new ListItem("Đề nghị hoãn việc chấp hành", ENUM_XLHC_DENGHI.HOAN));
            dropBienPhapGQ.Items.Add(new ListItem("Đề nghị miễn việc chấp hành", ENUM_XLHC_DENGHI.MIEN));
            dropBienPhapGQ.Items.Add(new ListItem("Đề nghị giảm thời hạn chấp hành", ENUM_XLHC_DENGHI.GIAM));
            dropBienPhapGQ.Items.Add(new ListItem("Đề nghị tạm đình chỉ chấp hành", ENUM_XLHC_DENGHI.TAM_DINHCHI));
            dropBienPhapGQ.Items.Add(new ListItem("Đề nghị miễn chấp hành phần thời gian còn lại", ENUM_XLHC_DENGHI.MIEN_CONLAI));
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            ddlNguoiky.DataSource = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlNguoiky.DataTextField = "MA_TEN";
            ddlNguoiky.DataValueField = "ID";
            ddlNguoiky.DataBind();
            ddlNguoiky.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));
        }

        private void LoadGrid_XuLyDon()
        {
            XLHC_SOTHAM_BL oBL = new XLHC_SOTHAM_BL();
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            DataTable oDT = oBL.XLHC_DONXIN_HOAN_MIEN_GETLIST_V2(DONID, ENUM_NGUOITIENHANHTOTUNG.THAMPHAN, pageindex, page_size);
            if (oDT.Rows.Count > 0)
            {
                DataRow row_last = oDT.Rows[0];
                LoadInfo_XuLyDon(Convert.ToDecimal(row_last["ID"] + ""));

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(oDT.Rows.Count, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
            }
            else
            {
                //Resetcontrol();
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có dữ liệu !";
            }

            rpt.DataSource = oDT;
            rpt.DataBind();
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal CurrID = Convert.ToDecimal(e.CommandArgument.ToString());
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");

            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Sua":
                    hddCurrID.Value = CurrID.ToString();
                    LoadInfo_XuLyDon(CurrID);
                    break;
                case "Xoa":
                    if (oPer.XOA == false || cmdCapNhat.Enabled == false)
                    {
                        lbtthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }

                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(DonID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID])); ;
                    if (Result != "")
                    {
                        lbtthongbao.Text = Result;
                        return;
                    }

                    if (coQuyenXoa(CurrID))
                    {
                        XLHC_DONXIN_HOAN_MIEN oT = dt.XLHC_DONXIN_HOAN_MIEN.Where(x => x.ID == CurrID).FirstOrDefault();
                        if (oT != null)
                        {
                            dt.XLHC_DONXIN_HOAN_MIEN.Remove(oT);
                        }
                        dt.SaveChanges();

                        hddPageIndex.Value = "1";
                        LoadGrid_XuLyDon();
                        lbtthongbao.Text = "Xóa thành công";
                    }

                    break;
                case "GiaiQuyet":
                    CurrID = Convert.ToDecimal(e.CommandArgument.ToString());
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "LoadModalDiv();");
                    XLHC_DONXIN_HOAN_MIEN oT1 = dt.XLHC_DONXIN_HOAN_MIEN.Where(x => x.ID == CurrID).FirstOrDefault();

                    var isGiaiQuyet = oT1 == null || oT1.ISGIAIQUYET == null ? 0 : oT1.ISGIAIQUYET;

                    string linkPop = "/QLAN/XLHC/SoTham/Popup/pGiaiQuyet.aspx?ID=" + CurrID + "&DON_ID=" + DonID + "&IS_GIAI_QUYET=" + isGiaiQuyet;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "onclick", "var Mleft = (screen.width/2)-(950/2); var Mtop = (screen.height/2)-(600/2); javascript:window.open('" + linkPop + "', '_blank', 'height=600px,width=950px,top=\'+Mtop+\', left=\'+Mleft+\',resizable=yes,toolbar=no,scrollbars=0'); ", true);
                    break;
            }
        }

        void LoadInfo_XuLyDon(Decimal CurrID)
        {
            XLHC_DONXIN_HOAN_MIEN obj = dt.XLHC_DONXIN_HOAN_MIEN.Where(x => x.ID == CurrID).Single<XLHC_DONXIN_HOAN_MIEN>();
            if (obj != null)
            {
                hddCurrID.Value = CurrID.ToString();
                if (obj.NGAYNHANDON != null) txtNgaynhan.Text = ((DateTime)obj.NGAYNHANDON).ToString("dd/MM/yyyy", cul);
                if (obj.NGAYVIETDON != null) txtNgayviet.Text = ((DateTime)obj.NGAYVIETDON).ToString("dd/MM/yyyy", cul);
                txtLyDo.Text = obj.LYDO;
                txtNguoiDungDon.Text = obj.NGUOI_DUNG_DON;
                dropBienPhapGQ.SelectedValue = obj.LOAIDON + "";
                rdbIsGiaiquyet.SelectedValue = (string.IsNullOrEmpty(obj.ISGIAIQUYET + "")) ? "0" : obj.ISGIAIQUYET.ToString();
                if (rdbIsGiaiquyet.SelectedValue == "0")
                    setTinhtrang(false);
                else
                {
                    setTinhtrang(true);
                    if (obj.GQ_NGAY != null) txtNgayGQ.Text = ((DateTime)obj.GQ_NGAY).ToString("dd/MM/yyyy", cul);
                    if (obj.GQ_NGUOIKY != null) ddlNguoiky.SelectedValue = obj.GQ_NGUOIKY.ToString();
                    rdbKetqua.SelectedValue = (string.IsNullOrEmpty(obj.GQ_ISCHAPNHAN + "")) ? "0" : obj.GQ_ISCHAPNHAN.ToString();
                }

                rdVuAnQuaHan.SelectedValue = (string.IsNullOrEmpty(obj.GQ_ISQUAHAN + "")) ? "0" : obj.GQ_ISQUAHAN.ToString();
                rdNNChuQuan.SelectedValue = (string.IsNullOrEmpty(obj.GQ_QUAHAN_CHUQUAN + "")) ? "0" : obj.GQ_QUAHAN_CHUQUAN.ToString();
                rdNNKhachQuan.SelectedValue = (string.IsNullOrEmpty(obj.GQ_QUAHAN_KHACHQUAN + "")) ? "0" : obj.GQ_QUAHAN_KHACHQUAN.ToString();

                pnNguyenNhanQuaHan.Visible = rdVuAnQuaHan.SelectedValue == "1";
                lbtDownloadHoanMien.Visible = (obj.TENFILE + "") != "";
            }
        }


        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid_XuLyDon();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid_XuLyDon();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid_XuLyDon();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid_XuLyDon();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            //dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid_XuLyDon();
        }

        #endregion
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadGrid_XuLyDon();
        }

        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            Resetcontrol();
        }

        void Resetcontrol()
        {
            txtLyDo.Text = ""; txtNgayviet.Text = "";
            txtNgaynhan.Text = "";
            rdbIsGiaiquyet.SelectedValue = "0";
            setTinhtrang(false);
            lbtthongbao.Text = "";
            hddFilePath_KC.Value = "";
            lbtDownloadHoanMien.Visible = true;
            txtNguoiDungDon.Text = "";
            hddCurrID.Value = "0";
        }

        protected void rdVuAnQuaHan_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdVuAnQuaHan.SelectedValue == "1")
                pnNguyenNhanQuaHan.Visible = true;
            else
                pnNguyenNhanQuaHan.Visible = false;
        }
        protected void cmdCapNhat_Click(object sender, EventArgs e)
        {
            if (txtNgaynhan.Text == "")
            {
                lbtthongbao.Text = "Chưa nhập ngày nhận đơn !";
                return;
            }
            if (txtNguoiDungDon.Text == "")
            {
                lbtthongbao.Text = "Chưa nhập người đứng đơn !";
                return;
            }
            if (txtLyDo.Text == "")
            {
                lbtthongbao.Text = "Chưa nhập lý do !";
                return;
            }
            if (rdbIsGiaiquyet.SelectedValue == "1")
            {
                if (txtNgayGQ.Text == "")
                {
                    lbtthongbao.Text = "Chưa nhập ngày giải quyết đơn !";
                    return;
                }
                if (rdbKetqua.SelectedValue == "")
                {
                    lbtthongbao.Text = "Chưa chọn kết quả giải quyết đơn !";
                    return;
                }
            }
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal DONID = Convert.ToDecimal(current_id);

            int DonXyLyID = 0;
            XLHC_DONXIN_HOAN_MIEN obj = new XLHC_DONXIN_HOAN_MIEN();
            if (hddCurrID.Value != "" && hddCurrID.Value != "0")
            {
                DonXyLyID = Convert.ToInt32(hddCurrID.Value);
                obj = dt.XLHC_DONXIN_HOAN_MIEN.Where(x => x.ID == DonXyLyID).FirstOrDefault();
                if (obj != null)
                {
                    obj.NGAYSUA = DateTime.Now;
                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                else obj = new XLHC_DONXIN_HOAN_MIEN();
            }
            else
                obj = new XLHC_DONXIN_HOAN_MIEN();

            obj.LYDO = txtLyDo.Text.Trim();
            obj.NGUOI_DUNG_DON = String.IsNullOrEmpty(txtNguoiDungDon.Text) ? null : txtNguoiDungDon.Text.Trim();
            obj.NGAYNHANDON = (String.IsNullOrEmpty(txtNgaynhan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaynhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYVIETDON = (String.IsNullOrEmpty(txtNgayviet.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayviet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.DONID = DONID;
            string bienphap = dropBienPhapGQ.SelectedValue;
            obj.LOAIDON = Convert.ToDecimal(bienphap);
            obj.ISGIAIQUYET = Convert.ToDecimal(rdbIsGiaiquyet.SelectedValue);
            obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            if (hddFilePath_KC.Value != "")
            {
                try
                {
                    string strFilePath = hddFilePath_KC.Value.Replace("/", "\\");
                    byte[] buff = null;
                    using (FileStream fs = File.OpenRead(strFilePath))
                    {
                        BinaryReader br = new BinaryReader(fs);
                        FileInfo oF = new FileInfo(strFilePath);
                        long numBytes = oF.Length;
                        buff = br.ReadBytes((int)numBytes);
                        obj.NOIDUNGFILE = buff;
                        obj.TENFILE = Cls_Comon.ChuyenTVKhongDau(oF.Name);
                        obj.KIEUFILE = oF.Extension;
                    }
                    File.Delete(strFilePath);
                }
                catch (Exception ex) { lbtthongbao.Text = ex.Message; }
            }

            if (obj.ISGIAIQUYET == 1)
            {
                obj.GQ_NGAY = (String.IsNullOrEmpty(txtNgayGQ.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayGQ.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.GQ_ISCHAPNHAN = Convert.ToDecimal(rdbKetqua.SelectedValue);
                if (ddlNguoiky.Items.Count > 0) obj.GQ_NGUOIKY = Convert.ToDecimal(ddlNguoiky.SelectedValue);
                obj.GQ_ISQUAHAN = rdVuAnQuaHan.SelectedValue == "" ? 0 : Convert.ToDecimal(rdVuAnQuaHan.SelectedValue);
                obj.GQ_QUAHAN_CHUQUAN = rdNNChuQuan.SelectedValue == "" ? 0 : Convert.ToDecimal(rdNNChuQuan.SelectedValue);
                obj.GQ_QUAHAN_KHACHQUAN = rdNNKhachQuan.SelectedValue == "" ? 0 : Convert.ToDecimal(rdNNKhachQuan.SelectedValue);
            }
            if (DonXyLyID == 0)
            {
                obj.NGAYTAO = obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.XLHC_DONXIN_HOAN_MIEN.Add(obj);
            }
            dt.SaveChanges();

            //-------------------------------------
            hddPageIndex.Value = "1";
            LoadGrid_XuLyDon();
            Resetcontrol();
            lbtthongbao.Text = "Lưu thành công!";
        }

        private void setTinhtrang(bool flag)
        {
            txtNgayGQ.Enabled = ddlNguoiky.Enabled = rdbKetqua.Enabled = rdVuAnQuaHan.Enabled = rdNNChuQuan.Enabled = rdNNKhachQuan.Enabled = flag;
        }

        protected void rdbIsGiaiquyet_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdbIsGiaiquyet.SelectedValue == "0")
                setTinhtrang(false);
            else
                setTinhtrang(true);
        }
        private void KiemTraDonXL()
        {
            // án chuyển đi rồi thì không hiển thị
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal donID = Convert.ToDecimal(current_id);
            var anXL = dt.XLHC_CHUYEN_NHAN_AN.Where(x => x.VUANID == donID).FirstOrDefault();
            if (anXL != null)
            {
                Cls_Comon.SetButton(cmdCapNhat, false);
                Cls_Comon.SetButton(cmdThemmoi, false);
                lbtthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi!";
            }
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // Lấy giá trị DONID từ Session
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal donID = Convert.ToDecimal(current_id);
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                LinkButton lbtGiaiQuyet = (LinkButton)e.Item.FindControl("lbtGiaiQuyet");
                var objXLHC_DONXIN_HOAN_MIEN = dt.XLHC_DONXIN_HOAN_MIEN.FirstOrDefault(x => x.DONID == donID);
                //// Kiểm tra vụ án đã chuyển chưa
                //var anXL = dt.XLHC_CHUYEN_NHAN_AN.FirstOrDefault(x => x.VUANID == donID);

                string StrMsg = "Không được sửa đổi thông tin.";
                string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(donID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    if (lbtXoa != null)
                        lbtXoa.Visible = false;
                    if (lblSua != null)
                        lblSua.Visible = false;
                    if (lbtGiaiQuyet != null)
                        lbtGiaiQuyet.Visible = false;
                }
                // check quyền để hiển thị nút xoá
                HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetID");
                string toaGiaiQuyetID = hddToaGiaiQuyetID.Value.ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toaGiaiQuyetID != donviID)
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;

                }

            }
        }

    }
}