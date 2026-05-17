using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.TONGDAT;
using DAL.GSTP;
using Module.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.GDTTT.Hoso
{
    public partial class DanhSachPH_HCTP : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public int indexDgDS = 1;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDrop();
                LoadData();
            }
        }
        public string GetDate(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return "";
                else
                    return Convert.ToDateTime(obj).ToString("dd/MM/yyyy");
            }
            catch (Exception ex)
            { return ""; }
        }
        private void LoadDrop()
        {
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            ddlToaXetXu.DataSource = dtTA;
            ddlToaXetXu.DataTextField = "MA_TEN";
            ddlToaXetXu.DataValueField = "ID";
            ddlToaXetXu.DataBind();
            ddlToaXetXu.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));

            DataTable dtTA2 = oTABL.DM_TOAAN_GETBYNOTCUR(0, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlToaKhac.DataSource = dtTA2;
            ddlToaKhac.DataTextField = "MA_TEN";
            ddlToaKhac.DataValueField = "ID";
            ddlToaKhac.DataBind();
            ddlToaKhac.Items.Insert(0, new ListItem("Các tòa địa phương", "-1"));
            ddlToaKhac.Items.Insert(0, new ListItem("--- Chọn tòa án --- ", "0"));

            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ddlPhongban.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == ToaAnID && (x.ISGIAIQUYETDON == 1 || x.ISGIAIQUYETDON == 2)).ToList();
            ddlPhongban.DataTextField = "TENPHONGBAN";
            ddlPhongban.DataValueField = "ID";
            ddlPhongban.DataBind();
            ddlPhongban.Items.Insert(0, new ListItem("--Chọn đơn vị--", "0"));
        }
        private void LoadData()
        {
            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vNoichuyen = Convert.ToDecimal(ddlNoichuyenden.SelectedValue);
            string SoBAQD = txtSoQDBA.Text.Trim(), NgayBAQD = txtNgayBAQD.Text, NguoiGui = txtNguoigui.Text.Trim();
            decimal ToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue), V_SO_TU = txtTuSo.Text == "" ? 0 : Convert.ToDecimal(txtTuSo.Text), V_SO_DEN = txtDenSo.Text == "" ? 0 : Convert.ToDecimal(txtDenSo.Text);
            string vTrangThai_PH = ddlTTPhatHanh.SelectedValue, V_LOAI_VB = ddlLoaiVanBan.SelectedValue;
            decimal vCD_DONVIID = 0;
            decimal vCD_TA_TRANGTHAI = -1;
            if (ddlNoichuyenden.SelectedValue == "0")
            {
                vCD_DONVIID = Convert.ToDecimal(ddlPhongban.SelectedValue);
                vCD_TA_TRANGTHAI = Convert.ToDecimal(ddlTrangthaidon.SelectedValue);
            }
            else if (ddlNoichuyenden.SelectedValue == "1")
            {
                vCD_DONVIID = Convert.ToDecimal(ddlToaKhac.SelectedValue);
            }
            string vCD_TENDONVI = txtNgoaitoaan.Text;
            decimal vIsThuLy = Convert.ToDecimal(ddlThuLy.SelectedValue);
            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            //Dùng kết hợp trong trường hợp chọn số tờ trình
            if ((vNoichuyen == 0 || vNoichuyen == -1) && ddlLoaiVanBan.SelectedValue == "7")
            {
                vCD_TENDONVI = "TTR";
            }
            else if (vNoichuyen == 2)
            {
                vCD_TENDONVI = txtNgoaitoaan.Text;
            }
            else
            {
                if (vCD_TENDONVI == "" && ddlLoaiVanBan.SelectedValue == "6")
                    vCD_TENDONVI = "CVPC";
            }
            DateTime? V_NGAY_FROM = txtNgayVBTu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayVBTu.Text, cul, DateTimeStyles.NoCurrentDateDefault)
               , V_NGAY_TO = txtNgayVBDen.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayVBDen.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
            TONGDAT_HCTP_BL objBL = new TONGDAT_HCTP_BL();
            DataTable tbl = new DataTable();
            if (ddlLoaiVanBan.SelectedValue == "6")
            {
                tbl = objBL.GDTTT_HCTP_PHATHANH_CONGVAN_SEARCH(ToaAnID, NguoiGui, SoBAQD, NgayBAQD, ToaRaBAQD, vLoaiAn, vTrangThai_PH, vNoichuyen, vCD_DONVIID, vCD_TA_TRANGTHAI, vCD_TENDONVI, V_LOAI_VB, V_SO_TU, V_SO_DEN, txtNgayVBTu.Text, txtNgayVBDen.Text, vIsThuLy, pageindex, page_size);
            }
            else if (ddlLoaiVanBan.SelectedValue == "7")
            {
                tbl = objBL.GDTTT_HCTP_PHATHANH_TOTRINH_SEARCH(ToaAnID, NguoiGui, SoBAQD, NgayBAQD, ToaRaBAQD, vLoaiAn, vTrangThai_PH, vNoichuyen, vCD_DONVIID, vCD_TA_TRANGTHAI, vCD_TENDONVI, V_LOAI_VB, V_SO_TU, V_SO_DEN, txtNgayVBTu.Text, txtNgayVBDen.Text, vIsThuLy, pageindex, page_size);
            }
            else tbl = objBL.GDTTT_HCTP_PHATHANH_DON_SEARCH(ToaAnID, NguoiGui, SoBAQD, NgayBAQD, ToaRaBAQD,  vLoaiAn, vTrangThai_PH, vNoichuyen,  vCD_DONVIID,vCD_TA_TRANGTHAI, vCD_TENDONVI, V_LOAI_VB, V_SO_TU, V_SO_DEN, txtNgayVBTu.Text, txtNgayVBDen.Text, vIsThuLy,pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                dgList.PageSize = tbl.Rows.Count;
                dgList.DataSource = tbl;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
                lbtthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }
        }

        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            lbtthongbao.Text = "";
            LoadData();
        }

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            txtNguoigui.Text = txtSoQDBA.Text = txtNgayBAQD.Text = txtTuSo.Text = txtDenSo.Text = txtNgayVBTu.Text = txtNgayVBDen.Text = "";
            ddlLoaiAn.SelectedValue = "0";
            ddlToaXetXu.SelectedValue = "0";
            ddlTTPhatHanh.SelectedValue = "4";
            ddlNoichuyenden.SelectedValue = "-1";
            ddlLoaiVanBan.SelectedValue = "-1";
            ddlThuLy.SelectedValue = ddlTrangthaidon.SelectedValue = "-1";
            lbtthongbao.Text = "";
            LoadData();
        }

        protected void cmdChuyenPH_Click(object sender, EventArgs e)
        {
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                if (chk.Checked)
                {
                    string[] arr = chk.ToolTip.Split('#');
                    int loaiVB = String.IsNullOrEmpty(arr[2] + "") ? 0 : Convert.ToInt16(arr[2] + "");
                    decimal donid = String.IsNullOrEmpty(arr[1] + "") ? 0 : Convert.ToDecimal(arr[1] + "");
                    decimal id = String.IsNullOrEmpty(arr[0] + "") ? 0 : Convert.ToDecimal(arr[0] + "");                   
                    if (id == 0)
                    {
                        TONGDAT_HCTP_BL oBL = new TONGDAT_HCTP_BL();
                        TONGDAT_HCTP oT = new TONGDAT_HCTP();
                        GDTTT_DON_BL oQLSO = new GDTTT_DON_BL();
                        oT.ID = 0;
                        oT.NGAYTAO = DateTime.Now;
                        oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oT.DON_ID = donid;
                        if (loaiVB == 6)
                        {                            
                            oT.LOAIVB = "Công văn chuyển";
                            GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == donid).FirstOrDefault();
                            oT.SOVB = oDon.CD_SOCV;
                            oT.NGAYVB = oDon.CD_NGAYCV;
                            oT.NGUOIKY = oDon.CD_NGUOIKY;
                            oT.TENVANBAN = "Công văn chuyển" + " số " + oT.SOVB + " ngày " + DateTime.Parse(oT.NGAYVB.ToString(), cul, DateTimeStyles.NoCurrentDateDefault).ToString("dd/MM/yyyy");                          
                        }
                        else if (loaiVB == 7)
                        {
                            oT.LOAIVB = "Tờ trình";
                            GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == donid).FirstOrDefault();
                            oT.SOVB = oDon.CD_SOTOTRINH;
                            oT.NGAYVB = oDon.CD_NGAYTOTRINH;
                            oT.NGUOIKY = oDon.CD_NGUOIKY;
                            oT.TENVANBAN = "Tờ trình" + " số " + oT.SOVB + " ngày " + DateTime.Parse(oT.NGAYVB.ToString(), cul, DateTimeStyles.NoCurrentDateDefault).ToString("dd/MM/yyyy");
                        }
                        else if (loaiVB == 1)
                        {
                            oT.LOAIVB = "Yêu cầu bổ sung";
                            GDTTT_DON_BL BL_DON = new GDTTT_DON_BL();
                            DataTable oYCBS = BL_DON.GDTTT_DON_YEUCAU_BOSUNG_GETBYID(donid);
                            oT.SOVB = oYCBS.Rows[0]["SOTHONGBAO"].ToString();
                            if (oYCBS.Rows[0]["NGAYTHONGBAO"].ToString() != "") oT.NGAYVB = Convert.ToDateTime(oYCBS.Rows[0]["NGAYTHONGBAO"].ToString());
                            oT.NGUOIKY = oYCBS.Rows[0]["NGUOIKY"].ToString();
                            oT.TENVANBAN = "Yêu cầu bổ sung" + " số " + oT.SOVB + " ngày " + DateTime.Parse(oT.NGAYVB.ToString(), cul, DateTimeStyles.NoCurrentDateDefault).ToString("dd/MM/yyyy");
                        }
                        else if (loaiVB == 2)
                        {
                            oT.LOAIVB = "Giấy xác nhận nhận đơn";
                            DataTable objQLSO = oQLSO.GET_GDTTT_HCTP_QLSO(donid);
                            oT.SOVB = objQLSO.Rows[0]["SO"].ToString();
                            if (objQLSO.Rows[0]["NGAYTHONGBAO"].ToString() != "") oT.NGAYVB = Convert.ToDateTime(objQLSO.Rows[0]["NGAY"].ToString());
                            oT.NGUOIKY = objQLSO.Rows[0]["NGUOIKY"].ToString();
                            oT.TENVANBAN = "Giấy xác nhận nhận đơn" + " số " + oT.SOVB + " ngày " + DateTime.Parse(oT.NGAYVB.ToString(), cul, DateTimeStyles.NoCurrentDateDefault).ToString("dd/MM/yyyy");
                        }
                        else if (loaiVB == 3)
                        {
                            oT.LOAIVB = "Trả lại đơn";
                            GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == donid && x.CD_LOAI == 3).FirstOrDefault();
                            oT.SOVB = oDon.CD_SOCV;
                            oT.NGAYVB = oDon.CD_NGAYCV;
                            oT.NGUOIKY = oDon.CD_NGUOIKY;
                            oT.TENVANBAN = "Trả lại đơn" + " số " + oT.SOVB + " ngày " + (oT.NGAYVB == null ? "" : DateTime.Parse(oT.NGAYVB.ToString(), cul, DateTimeStyles.NoCurrentDateDefault).ToString("dd/MM/yyyy")); 
                        }
                        else if (loaiVB == 4)
                        {
                            oT.LOAIVB = "Thông báo phân công thẩm phán";
                            DataTable objQLSO = oQLSO.GET_GDTTT_HCTP_QLSO(donid);
                            oT.SOVB = objQLSO.Rows[0]["SO"].ToString();
                            if (objQLSO.Rows[0]["NGAYTHONGBAO"].ToString() != "") oT.NGAYVB = Convert.ToDateTime(objQLSO.Rows[0]["NGAY"].ToString());
                            oT.NGUOIKY = objQLSO.Rows[0]["NGUOIKY"].ToString();
                            oT.TENVANBAN = "Thông báo phân công thẩm phán" + " số " + oT.SOVB + " ngày " + DateTime.Parse(oT.NGAYVB.ToString(), cul, DateTimeStyles.NoCurrentDateDefault).ToString("dd/MM/yyyy");
                        }
                        else if (loaiVB == 5)
                        {
                            oT.LOAIVB = "Thông báo gửi cơ quan chuyển đơn";
                            DataTable objQLSO = oQLSO.GET_GDTTT_HCTP_QLSO(donid);
                            oT.SOVB = objQLSO.Rows[0]["SO"].ToString();
                            if (objQLSO.Rows[0]["NGAYTHONGBAO"].ToString() != "") oT.NGAYVB = Convert.ToDateTime(objQLSO.Rows[0]["NGAY"].ToString());
                            oT.NGUOIKY = objQLSO.Rows[0]["NGUOIKY"].ToString();
                            oT.TENVANBAN = "Thông báo gửi cơ quan chuyển đơn" + " số " + oT.SOVB + " ngày " + DateTime.Parse(oT.NGAYVB.ToString(), cul, DateTimeStyles.NoCurrentDateDefault).ToString("dd/MM/yyyy");
                        }
                        decimal phongBanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                        DM_PHONGBAN pb = dt.DM_PHONGBAN.Where(x => x.ID == phongBanID).FirstOrDefault();
                        oT.DONVIPHATHANH_ID = phongBanID;
                        oT.DONVIPHATHANH = pb.TENPHONGBAN;
                        oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        oT.ID = oBL.TONGDAT_HCTP_INS_UPD(oT);
                        //Add đối tượng
                        DataTable objDT = oBL.GET_VBPH_NOINHAN_DOITUONG(donid, loaiVB);
                        List<Object> arrDoiTuong = new List<object>();
                        if (objDT.Rows.Count > 0)
                        {
                            foreach (DataRow d in objDT.Rows)
                            {
                                TONGDAT_HCTP_NOINHAN oN = new TONGDAT_HCTP_NOINHAN();
                                oN.ID = 0;
                                oN.NGAYGUI = DateTime.Now;
                                oN.DOITUONG = 0;
                                oN.TRANGTHAI = 1;
                                oN.NGAYTAO = DateTime.Now;
                                oN.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                oN.NOINHAN = d["NOINHAN"] + "";
                                oN.DIACHI = d["DIACHI"] + "";
                                oN.TUCACHTOTUNG = d["TUCACHTOTUNG"] + "";
                                oN.TONGDAT_HCTP_ID = oT.ID;
                                oN.HINHTHUCGUI = 2;
                                oN.NGAYGUI = DateTime.Now;
                                oBL.TONGDAT_HCTP_NOINHAN_INS_UPD(oN);
                                var oDT = new
                                {
                                    noiNhan = oN.NOINHAN,
                                    tuCachToTung = oN.TUCACHTOTUNG == null ? "" : oN.TUCACHTOTUNG,
                                    diaChi = oN.DIACHI,
                                    hinhThucGui = oN.HINHTHUCGUI,
                                    phatHanhLaiId = oN.PHATHANHLAI_ID == null ? 0 : oN.PHATHANHLAI_ID,
                                    noiNhanId = oN.ID
                                };
                                arrDoiTuong.Add(oDT);
                            }
                        }
                        //try
                        //{
                        //    //gọi api tongdat_hctp
                        //    WebClient client = new WebClient();
                        //    string apiUrl = ConfigurationManager.AppSettings["IpTongDat"] + "tongdat_hctp";
                        //    var input = new
                        //    {
                        //        id = oT.ID,
                        //        tenVanBan = oT.TENVANBAN,
                        //        soVB = oT.SOVB,
                        //        ngayVB = oT.NGAYVB,
                        //        nguoiKy = oT.NGUOIKY == null ? "" : oT.NGUOIKY,
                        //        donViPhatHanh = oT.DONVIPHATHANH,
                        //        toaAnId = oT.TOAANID,
                        //        doiTuong = arrDoiTuong
                        //    };
                        //    var objInput = new object[] { input };
                        //    string inputJson = JsonConvert.SerializeObject(objInput);
                        //    client.Headers.Clear();
                        //    client.Headers.Add(HttpRequestHeader.ContentType, "application/json");
                        //    client.Encoding = Encoding.UTF8;
                        //    string result = client.UploadString(apiUrl, inputJson);
                        //    if (result != "SUCCESS")
                        //    {
                        //        lbtthongbao.Text = result;
                        //        return;
                        //    }
                        //}
                        //catch (Exception ex)
                        //{
                        //    lbtthongbao.Text = ex.Message;
                        //}
                    }                    
                }
            }
            
            lbtthongbao.Text = "Chuyển phát hành thành công!";
            LoadData();
        }

        protected void ddlNoichuyenden_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (ddlNoichuyenden.SelectedValue)
            {
                case "0":
                    ddlPhongban.Visible = true;
                    ddlTrangthaidon.Visible = true;
                    pnToakhac.Visible = false;
                    txtNgoaitoaan.Visible = false;
                    break;
                case "1":
                    ddlPhongban.Visible = false;
                    ddlTrangthaidon.Visible = false;
                    pnToakhac.Visible = true;
                    txtNgoaitoaan.Visible = false;
                    break;
                case "2":
                    ddlPhongban.Visible = false;
                    ddlTrangthaidon.Visible = false;
                    pnToakhac.Visible = false;
                    txtNgoaitoaan.Visible = true;
                    break;
                case "3":
                    ddlPhongban.Visible = false;
                    ddlTrangthaidon.Visible = false;
                    pnToakhac.Visible = false;
                    txtNgoaitoaan.Visible = false;
                    break;
                default:
                    ddlPhongban.Visible = false;
                    ddlTrangthaidon.Visible = false;
                    pnToakhac.Visible = false;
                    txtNgoaitoaan.Visible = false;
                    break;
            }
        }

        protected void ddlPhongban_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadLoaiAn(Convert.ToDecimal(ddlPhongban.SelectedValue));
        }
        private void LoadLoaiAn(decimal PBID)
        {
            ddlLoaiAn.Items.Clear();
            if (PBID > 0)
            {
                DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();
                if (obj.ISHINHSU == 1) ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                if (obj.ISDANSU == 1) ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
                if (obj.ISHANHCHINH == 1) ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
                if (obj.ISHNGD == 1) ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
                if (obj.ISKDTM == 1) ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
                if (obj.ISLAODONG == 1) ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
                if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            }
            else
            {
                ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
                ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
                ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
                ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
                ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
                ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            }
            ddlLoaiAn.Items.Add(new ListItem("Chưa xác định", "55"));
            ddlLoaiAn.Items.Insert(0, new ListItem("Tất cả", "0"));
            //----------anhvh add 20/08/2020 check thêm nếu là phó chánh an thì chỉ lấy những loại án của PCA đó-------------------------
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadData();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadData();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            //  dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadData();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            // dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadData();
        }
        #endregion

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Sua":
                    string[] arrSua = e.CommandArgument.ToString().Split('#');
                    decimal idSua = String.IsNullOrEmpty(arrSua[0] + "") ? 0 : Convert.ToDecimal(arrSua[0] + "");
                    int loaiVB_Sua = String.IsNullOrEmpty(arrSua[2] + "") ? 0 : Convert.ToInt16(arrSua[2] + "");
                    decimal donid_Sua = String.IsNullOrEmpty(arrSua[1] + "") ? 0 : Convert.ToDecimal(arrSua[1] + "");
                    Session[ENUM_GDTTT_TONGDAT_HCTP.IS_PHBS] = "0";
                    Session[ENUM_GDTTT_TONGDAT_HCTP.IS_PHATHANHLAI] = "0";
                    string StrMsgPhatHanhSua = "PopupReport('/QLAN/GDTTT/Hoso/Popup/pPhatHanh_HCTP.aspx?vID=" + loaiVB_Sua + "&vLoaiVB=" + donid_Sua + "&vIDSua=" + idSua + "','Phát hành văn bản',1260,800);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgPhatHanhSua, true);
                    break;
                case "PhatHanh":
                    string[] arr = e.CommandArgument.ToString().Split('#');
                    int loaiVB = String.IsNullOrEmpty(arr[1] + "") ? 0 : Convert.ToInt16(arr[1] + "");
                    decimal donid = String.IsNullOrEmpty(arr[0] + "") ? 0 : Convert.ToDecimal(arr[0] + "");
                    Session[ENUM_GDTTT_TONGDAT_HCTP.IS_PHBS] = "0";
                    Session[ENUM_GDTTT_TONGDAT_HCTP.IS_PHATHANHLAI] = "0";
                    string StrMsgPhatHanh = "PopupReport('/QLAN/GDTTT/Hoso/Popup/pPhatHanh_HCTP.aspx?vID=" + donid + "&vLoaiVB=" + loaiVB + "&vIDSua=" + 0 + "','Phát hành văn bản',1260,800);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgPhatHanh, true);
                    break;
                case "Xoa":
                    decimal id = String.IsNullOrEmpty(e.CommandArgument.ToString()) ? 0 : Convert.ToDecimal(e.CommandArgument.ToString());
                    TONGDAT_HCTP_BL oBL = new TONGDAT_HCTP_BL();
                    oBL.TONGDAT_HCTP_DEL(id);
                    lbtthongbao.Text = "Xóa thành công";
                    LoadData();
                    break;
            }
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton lblPhatHanh = (LinkButton)e.Item.FindControl("lblPhatHanh");
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Panel pn_ttb = (Panel)e.Item.FindControl("pn_TTD");
                int pageindex = Convert.ToInt32(hddPageIndex.Value);
                int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
                if (rowView["RN"] + "" == "1")
                {
                    e.Item.Cells[0].RowSpan = Convert.ToInt16(rowView["ROWSPAN"] + "");
                    e.Item.Cells[1].Text = ((pageindex - 1) * page_size + indexDgDS) + "";
                    indexDgDS++;
                    e.Item.Cells[1].RowSpan = Convert.ToInt16(rowView["ROWSPAN"] + "");
                    e.Item.Cells[2].RowSpan = Convert.ToInt16(rowView["ROWSPAN"] + "");
                    e.Item.Cells[8].RowSpan = Convert.ToInt16(rowView["ROWSPAN"] + "");
                    e.Item.Cells[9].RowSpan = Convert.ToInt16(rowView["ROWSPAN"] + "");
                }
                else
                {
                    e.Item.Cells[0].Visible = false;
                    e.Item.Cells[1].Visible = false;
                    e.Item.Cells[2].Visible = false;
                    e.Item.Cells[8].Visible = false;
                    e.Item.Cells[9].Visible = false;
                }
                if(rowView["LOAIVB"] + "" != "6" && rowView["LOAIVB"] + "" != "7" && rowView["LOAIVB"] + "" != "4")
                {
                    pn_ttb.Visible = true;
                }
                //if (rowView["TRANGTHAI"] + "" == "Phát hành không thành công")
                //{
                //    if (rowView["HAS_PHATHANHLAI"] + "" == "1") cmdPHLai.Visible = true;
                //    if (rowView["IS_SUA"] + "" == "0") cmdVBHDSua.Visible = true;
                //    else cmdVBDHDong.Visible = true;
                //}
                //else if (rowView["TRANGTHAI"] + "" == "Phát hành thành công")
                //{
                //    if (rowView["IS_SUA"] + "" == "0") cmdVBHDSua.Visible = true;
                //    else cmdVBDHDong.Visible = true;
                //}
                if (rowView["ID"] + "" == "0")
                {
                    lblPhatHanh.Visible = true;
                }
                else
                {
                    if(rowView["TRANGTHAI"] + "" != "")
                    {
                        //lbtXoa.Visible = true;
                        lblSua.Visible = true;
                    }                   
                }
            }
        }

        protected void chkChonAll_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                chk.Checked = chkAll.Checked;
            }
        }
    }
}