<%@ Page Language="C#" MasterPageFile="~/MasterPages/AN_PHI.Master" AutoEventWireup="true" CodeBehind="QuanLy.aspx.cs" Inherits="WEB.TP.QuanLy" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="/UI/js/Common_01.js"></script>
    <div class="content_form">
        <div class="content_body">
            <div class="content_form_head">
                <div class="content_form_head_title">Thông tin tạm ứng án phí</div>
                <div class="content_form_head_right"></div>
            </div>
            <div class="content_form_body">
                <div class="searchcontent">
                    <h4 class="tracuu_tleboxchung">Tìm kiếm
                        <asp:LinkButton ID="lbtTTTK" runat="server" Text="[ Nâng cao ]" ForeColor="#0E7EEE" OnClick="lbtTTTK_Click" Enabled="false"></asp:LinkButton></h4>
                    <div class="border_search">
                        <asp:HiddenField ID="hddSearchStatus" runat="server" Value="0" />
                        <asp:Panel ID="pnTTTK" runat="server" Visible="true">
                            <table style="width: 100%;" id="tblSearchAdvance">
                                <tr>
                                    <td>
                                        <div style="float: left; width: 100%; margin-top: 0px;">
                                            <div style="float: left; width: 150px;">Trạng thái </div>
                                            <div style="float: left;">
                                                <asp:DropDownList CssClass="chosen-select" ID="rdTrangThai" runat="server" Width="180px" AutoPostBack="true">
                                                    <asp:ListItem Text="Chưa nộp án phí" Value="0" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Text="Đã nộp án phí" Value="1"></asp:ListItem>
                                                    <asp:ListItem Text="Đã hoàn trả án phí" Value="2"></asp:ListItem>
                                                    <asp:ListItem Text="Đình chỉ nộp án phí" Value="3"></asp:ListItem>
                                                    <asp:ListItem Text="Tất cả" Value=""></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                            <div style="float: left; padding-top: 5px; width: 136px; margin-left: 7px;">Hình thức thanh toán</div>
                                            <div style="float: left; margin-left: 10px;">
                                                <asp:DropDownList CssClass="chosen-select" ID="ddl_TRUCTUYEN" runat="server" Width="180px">
                                                    <asp:ListItem Value="" Selected="True" Text="Tất cả"></asp:ListItem>
                                                    <asp:ListItem Value="0" Text="Trực tiếp"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Trực tuyến"></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                            <div style="float: left; width: 90px; margin-left: 7px;margin-top: 5px;">Trạng thái gửi </div>
                                            <div style="float: left; margin-left: 10px;">
                                                <asp:DropDownList CssClass="chosen-select" ID="ddl_TRANG_THAI" runat="server" Width="115px">
                                                    <asp:ListItem Value="" Selected="True" Text="Tất cả"></asp:ListItem>
                                                    <asp:ListItem Value="0" Text="Đang lưu"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Đã gửi"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Đã thu hồi"></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="float: left; width: 100%; margin-top: 5px;">
                                            <div style="float: left; margin-top: 7px; font-size: 13px; width: 150px;">Loại án</div>
                                            <div style="float: left; margin-left: 0px;">
                                                <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select"
                                                    runat="server" Width="180px">
                                                </asp:DropDownList>
                                            </div>
                                            <div style="float: left; padding-top: 5px; width: 136px; margin-left: 7px; font-size: 12px;">File biên lai của THADS</div>
                                            <div style="float: left; margin-left: 10px;">
                                                <asp:DropDownList CssClass="chosen-select" ID="ddl_FILE_THADS" runat="server" Width="180px">
                                                    <asp:ListItem Value="" Selected="True" Text="Tất cả"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Đã có"></asp:ListItem>
                                                    <asp:ListItem Value="0" Text="Chưa có"></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="float: left; width: 100%; margin-top: 5px;">
                                            <div style="float: left; width: 150px;">Từ khóa</div>
                                            <div style="float: left;">
                                                <asp:TextBox ID="txtDuongSu" runat="server"
                                                    placeholder="(Nhập mã thông báo, số thông báo, số CMTND/Thẻ căn cước hoặc tên đương sự để thực hiện tra cứu thông tin nộp án phí)"
                                                    CssClass="textbox" Width="719px"></asp:TextBox>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="tr_thads" runat="server" style="">
                                    <td>

                                        <div style="float: left;">
                                            <div style="float: left; width: 100%; margin-top: 5px;">
                                                <div style="float: left; padding-top: 5px; width: 150px;">Chọn đơn vị</div>
                                                <div style="float: left; margin-left: 0px;">
                                                    <asp:DropDownList CssClass="chosen-select" ID="ddlDonvi" runat="server" Width="734px">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div style="float: left; width: 100%; margin-top: 5px; display: none;" runat="server" id="div_baogom_capcon">
                                                <div style="float: left; padding-top: 5px; width: 150px;">Phạm vi tìm kiếm</div>
                                                <div style="float: left; margin-left: 0px;">
                                                    <asp:DropDownList CssClass="chosen-select" ID="ddlLoaiNhom" runat="server" Width="247px">
                                                        <asp:ListItem Value="0" Text="Bao gồm cấp con"></asp:ListItem>
                                                        <asp:ListItem Value="1" Selected="True" Text="Chỉ thuộc đơn vị"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <%--<asp:HiddenField ID="hddNGDCID" runat="server" Value="" />
                                                <asp:TextBox ID="txt_DONVITHIHANHAN" runat="server"
                                                    CssClass="textbox" Width="640px" MaxLength="250"></asp:TextBox>--%>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="float: left; width: 100%; margin-top: 5px;">
                                            <div style="float: left; width: 150px; margin-top: 10px;">Ngày thông báo từ ngày</div>
                                            <div style="margin-top: 5px;">
                                                <span style="float: left">
                                                    <asp:TextBox ID="txtTuNgay" runat="server" CssClass="textbox"
                                                        placeholder="......./....../....." Width="120px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </span>
                                                <span style="margin-left: 5px; margin-right: 5px; line-height: 22px; float: left;">Đến ngày</span>
                                                <span style="float: left; margin-right: 2px;">
                                                    <asp:TextBox ID="txtDenNgay" runat="server" CssClass="textbox"
                                                        placeholder="......./....../....." Width="120px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </span>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="margin-top: 5px; margin-left: 540px;">
                                            <asp:Button ID="cmdSearch1" runat="server" CssClass="button_search2"
                                                Text="Tìm kiếm" OnClick="cmdSearch_Click" />
                                            <asp:Button ID="btn_print_list" runat="server"
                                                CssClass="button" Text="In danh sách" OnClick="btn_print_list_Click" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="pn_search_basic" runat="server" Visible="true">
                            <table style="width: 100%;" id="tblBasicSearch" runat="server">
                                <tr>
                                    <td>
                                        <asp:TextBox ID="txtTuKhoaBasic" runat="server"
                                            placeholder="(Nhập số thông báo, số CMTND/Thẻ căn cước hoặc tên đương sự để thực hiện tra cứu thông tin nộp án phí)"
                                            CssClass="textbox_searchbasic"></asp:TextBox>
                                        <div style="margin-left: 10px; float: left;">
                                            <asp:Button ID="cmdSearch" runat="server" CssClass="button_search2"
                                                Text="Tìm kiếm" OnClick="cmdSearch_Click" />
                                        </div>
                                        <asp:Button ID="Button2" runat="server" OnClick="btn_print_list_Click"
                                            CssClass="button" Text="In danh sách" /></td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </div>
                </div>
                <div class="msg_thongbao">
                    <asp:Literal ID="lbthongbao" runat="server"></asp:Literal>
                </div>
                <!-------------------------------------------->
                <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                <asp:Panel ID="pnDS" runat="server">
                    <div class="phantrang" runat="server" id="div_phantrang_top" style="display: none">
                        <div class="sobanghi">
                            <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                        </div>
                        <div class="sotrang">
                            <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                OnClick="lbTBack_Click"><</asp:LinkButton>
                            <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                            <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                OnClick="lbTNext_Click">></asp:LinkButton>
                            <asp:DropDownList ID="dropPageSize" runat="server" Width="65px"
                                CssClass="dropbox"
                                AutoPostBack="True" OnSelectedIndexChanged="dropPageSize_SelectedIndexChanged">
                                <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                <asp:ListItem Value="500" Text="500"></asp:ListItem>
                            </asp:DropDownList>

                        </div>
                    </div>
                    <div>
                        <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" Visible="true" OnItemDataBound="rpt_ItemDataBound">
                            <HeaderTemplate>
                                <div class="CSSTableGenerator">
                                    <table>
                                        <tr id="row_header">
                                            <td style="width: 20px;">TT</td>
                                            <td style="width: 150px;">Thông tin vụ việc</td>
                                            <td style="width: 300px;">Thông tin đương sự</td>
                                            <td style="width: 300px;" id="td_header_hoantra" runat="server">Thông tin người nhận hoàn trả tiền tạm ứng án phí</td>
                                            <td style="width: 200px;" runat="server" id="td_header_toaan">Tòa án giải quyết</td>
                                            <td style="width: 100px;" runat="server" id="td_header_TAMUNGANPHI">Số tiền tạm ứng án phí (VNĐ)</td>
                                            <td style="width: 100px;" runat="server" id="td_header_ANPHIHOANTRA">Số tiền hoàn trả (VNĐ)</td>
                                            <td style="width: 150px;" runat="server" id="td_header_trangthai">Trạng thái</td>
                                            <td style="width: 170px;" runat="server" id="td_header_xacnhan">Thông tin nộp tiền tạm ứng án phí</td>
                                            <td style="width: 200px;" runat="server" id="td_header_xacnhanhoantra">Thông tin nhận hoàn trả tiền tạm ứng án phí</td>
                                            <td style="width: 60px;" runat="server" id="td_header_FILEID">Thông báo của Tòa án</td>
                                            <td style="width: 170px;" runat="server" id="td_header_thaotac">Thao tác</td>
                                        </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td style="text-align: center;"><%#Eval("STT") %> </td>
                                    <td style="text-align: center;">
                                        <ul>
                                            <li style="text-align: left;"><i>Mã thông báo:</i> <%#Eval("MA_THONGBAO")%></li>
                                            <li style="text-align: left;"><i>Số thông báo:</i> <%#Eval("SOTHONGBAO")%></li>
                                            <li style="text-align: left;"><i>Ngày:</i> <%#Eval("NGAYTHONGBAO")%></li>
                                            <li style="text-align: left;"><i>Mã vụ việc:</i> <%#Eval("MAVUVIEC")%></li>
                                            <li style="text-align: left;"><i>Loại án:</i> <%#Eval("LOAIAN")%></li>
                                        </ul>
                                    </td>
                                    <td>
                                        <ul>
                                            <li><%#Eval("TENDUONGSU")%></li>
                                            <%--  <li>Năm sinh: <%#Eval("NAMSINH")%></li>
                                            <li>CMND: <%#Eval("SOCMND")%></li>
                                            <li>Điện thoại: <%#Eval("DIENTHOAI")%></li>
                                            <li>Email: <%#Eval("EMAIL")%></li>
                                            <li>Địa chỉ: <%#Eval("DIACHI")%></li>--%>
                                        </ul>
                                    </td>
                                    <td id="td_item_hoantra" runat="server">
                                        <ul>
                                            <li>Họ tên: <span style="font-weight: bold; font-size: 14px;"><%#Eval("HOANTRAAP_HOTEN")%></span></li>
                                            <li>Năm sinh: <%#Eval("HOANTRAAP_NAMSINH")%></li>
                                            <li>CMND: <%#Eval("HOANTRAAP_CMND")%></li>
                                            <li>Điện thoại: <%#Eval("HOANTRAAP_TEL")%></li>
                                            <li>Email: <%#Eval("HOANTRAAP_EMAIL")%></li>
                                            <li>Địa chỉ: <%#Eval("HOANTRAAP_DIACHI")%></li>
                                        </ul>
                                    </td>
                                    <td runat="server" id="td_item_toaan"><%#Eval("DONVI")%></td>
                                    <td style="text-align: center;" runat="server" id="td_item_TAMUNGANPHI"><%#Eval("TAMUNGANPHI")%> </td>
                                    <td style="text-align: center;" runat="server" id="td_item_ANPHIHOANTRA"><%#Eval("ANPHIHOANTRA")%> </td>
                                    <td id="td_item_trangthai" style="text-align: left;" runat="server">
                                        <ul>
                                            <li>Hình thức:<b style="color: #ff0000;"> <%#Eval("HINH_THUC")%></b></li>
                                            <li><%#Eval("TRANG_THAI")%></li>
                                            <li><%#Eval("STATUS")%></li>
                                            <li><%#Eval("STATUS_HOANTRA")%></li>
                                        </ul>
                                    </td>
                                    <%-- <td id="td_item_xacnhan" runat="server">
                                        <ul>
                                            <li>Ngày biên lai: <%#Eval("NGAYBIENLAI")%></li>
                                            <li>Số biên lai: <%#Eval("SOBIENLAI")%></li>
                                            <li>Người thu: <%#Eval("NGUOITHUTIEN")%></li>
                                        </ul>
                                    </td>--%>
                                    <td id="td_item_xacnhan_tt" runat="server">
                                        <div class="align_left">
                                            <div style="float: left">
                                                <ul>
                                                    <li>Ngày biên lai: <%#Eval("NGAYBIENLAI")%></li>
                                                    <li>Số biên lai: <%#Eval("SOBIENLAI")%></li>
                                                    <li>Người thu: <%#Eval("NGUOITHUTIEN")%></li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="align_center">
                                            <div style="float: left; margin-left: 40px; margin-top: 10px;">
                                                <asp:ImageButton ID="Dowload_Bienlai" runat="server" CausesValidation="false"
                                                    OnClick="cmdFile_Attach_Click" CommandName="DowloadBienlais" CommandArgument='<%#Eval("MA_THONGBAO").ToString()+";"+Eval("DVCQG_TT_ID")%>'
                                                    ImageUrl="/UI/img/download_file26.png" ToolTip="file biên lai từ Dịch vụ công trả về" />
                                            </div>
                                            <div style="float: left; margin-left: 10px; margin-top: 10px;">
                                                <asp:ImageButton ID="Dowload_Bienlai_thads" runat="server" CausesValidation="false"
                                                    OnClick="cmdFile_Attach_thads_Click" CommandName="DowloadBienlaithads" CommandArgument='<%#Eval("ANPHI_ID").ToString()+";"+ Eval("MALOAIVUVIEC").ToString() %>'
                                                    ImageUrl="/UI/img/Manager/pdf_blues.png" ToolTip="file biên lai từ Thi hành án dân sự cập nhật vào hệ thống" />
                                            </div>
                                        </div>
                                    </td>
                                    <td id="td_item_xacnhanhoantra" runat="server">
                                        <ul>
                                            <li>Ngày nhận: <%#Eval("NGAYHOANTRA")%></li>
                                            <li>Số biên lai: <%#Eval("SOBIENLAI")%></li>
                                            <li>Người thu: <%#Eval("NGUOITHUTIEN")%></li>
                                        </ul>
                                    </td>
                                    <td id="td_FILEID" runat="server">
                                        <div class="align_center">
                                            <asp:ImageButton ID="cmdDowload" runat="server"
                                                CommandName="Dowload_s" CommandArgument='<%#Eval("TONGDATID")+";"+Eval("MALOAIVUVIEC")+";"+ Eval("FILEID").ToString()+";"+Eval("URL_FILE") %>'
                                                ImageUrl="/UI/img/download_file26.png" OnClick="cmdDowload_Click" />
                                        </div>
                                    </td>
                                    <td id="td_item_thaotac" runat="server" style="text-align: left;">
                                        <a class="link_nopap" href="javascript:;" onclick="nopanphi('<%#Eval("TUPHAP_ANPHI_ID")%>','<%#Eval("MA_THONGBAO")%>','<%#Eval("DONID")%>','<%#Eval("DUONGSU_ID")%>','<%#Eval("MALOAIVUVIEC").ToString()%>','<%#Eval("BIEUMAUID")%>','<%#Eval("DUONGSU_IDS")%>','<%#Eval("ANPHI_ID")%>','<%#Eval("DVCQG_TT_ID")%>','0')">Cập nhật thông tin nộp án phí</a>
                                        <div style="color: #000000; margin-top: 7px;">
                                          <div><i>Người sửa:</i> <%#Eval("NGUOISUA")%></div>
                                            <div><i>Ngày sửa:</i> <%#Eval("NGAYSUA")%></div>
                                        </div>
                                    </td>
                                    <td style="text-align: left; color: blue" id="td_item_xembienlai" runat="server">
                                        <p style="text-align: left;"><a class="link_nopap" href="javascript:;" onclick="nopanphi('<%#Eval("TUPHAP_ANPHI_ID")%>','<%#Eval("MA_THONGBAO")%>','<%#Eval("DONID")%>','<%#Eval("DUONGSU_ID")%>','<%#Eval("MALOAIVUVIEC").ToString()%>','<%#Eval("BIEUMAUID")%>','<%#Eval("DUONGSU_IDS")%>','<%#Eval("ANPHI_ID")%>','<%#Eval("DVCQG_TT_ID")%>','1')">Sửa thông tin nộp án phí</a></p>
                                        <p style="text-align: left; margin-top: 10px;">
                                            <a class="link_nopap" style="color: #9f1a12;" href="javascript:;" onclick="nopanphi('<%#Eval("TUPHAP_ANPHI_ID")%>','<%#Eval("MA_THONGBAO")%>','<%#Eval("DONID")%>','<%#Eval("DUONGSU_ID")%>','<%#Eval("MALOAIVUVIEC").ToString()%>','<%#Eval("BIEUMAUID")%>','<%#Eval("DUONGSU_IDS")%>','<%#Eval("ANPHI_ID")%>','<%#Eval("DVCQG_TT_ID")%>','2')">
                                                <asp:Label ID="lbl_hoantra" runat="server" Text="Cập nhật thông tin hoàn trả án phí"></asp:Label></a>
                                        </p>
                                        <p style="text-align: left; margin-top: 10px;">
                                            <asp:LinkButton ID="lblSua" runat="server" Text="Xem biên lai" CausesValidation="false" CommandName="xembienlai" ForeColor="#9f1a12" Font-Italic="true"
                                                CommandArgument='<%#Eval("MA_THONGBAO").ToString() +";"+Eval("DONID").ToString() +";"+ Eval("MALOAIVUVIEC").ToString()+";"+ Eval("DUONGSU_ID").ToString()+";"+ Eval("DUONGSU_IDS").ToString()%>'></asp:LinkButton>
                                        </p>
                                        <div style="color: #000000; margin-top: 7px;">
                                                <div><i>Người sửa:</i> <%#Eval("NGUOISUA")%></div>
                                            <div><i>Ngày sửa:</i> <%#Eval("NGAYSUA")%></div>
                                        </div>
                                    </td>
                                    <td style="text-align: left; color: blue" id="td_item_xemhoantra" runat="server">
                                        <p style="text-align: center; margin-top: 8px;"><a class="link_nopap" style="color: #9f1a12;" href="javascript:;" onclick="nopanphi('<%#Eval("TUPHAP_ANPHI_ID")%>','<%#Eval("MA_THONGBAO")%>','<%#Eval("DONID")%>','<%#Eval("DUONGSU_ID")%>','<%#Eval("MALOAIVUVIEC").ToString()%>','<%#Eval("BIEUMAUID")%>','<%#Eval("DUONGSU_IDS")%>','<%#Eval("ANPHI_ID")%>','<%#Eval("DVCQG_TT_ID")%>','2')">Sửa thông tin hoàn trả án phí</a></p>
                                        <div style="color: #000000; margin-top: 7px;">
                                                <div><i>Người sửa:</i> <%#Eval("NGUOISUA")%></div>
                                            <div><i>Ngày sửa:</i> <%#Eval("NGAYSUA")%></div>
                                        </div>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                </table></div>
                            </FooterTemplate>
                        </asp:Repeater>
                    </div>
                    <div class="phantrang" id="div_phantrang_bottom" runat="server" style="display: none;">
                        <div class="sobanghi">
                            <asp:HiddenField ID="hdicha" runat="server" />
                            <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                        </div>
                        <div class="sotrang">
                            <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                OnClick="lbTBack_Click"><</asp:LinkButton>
                            <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>

                            <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                OnClick="lbTNext_Click">></asp:LinkButton>
                            <asp:DropDownList ID="dropPageSize2" runat="server" Width="65px" CssClass="dropbox"
                                AutoPostBack="True" OnSelectedIndexChanged="dropPageSize2_SelectedIndexChanged">
                                <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                <asp:ListItem Value="500" Text="500"></asp:ListItem>
                            </asp:DropDownList>

                        </div>
                    </div>
                    <script>
                        $(document).ready(function () {
                            $('input[type=text]').on('keypress', function (e) {
                                if (e.which == 13) {
                                    $("#<%= cmdSearch1.ClientID %>").click();
                                }
                            });
                        });
                        function nopanphi(TUPHAP_ANPHI_ID, MA_THONGBAO, _DON_ID, _DUONGSU_ID, _MALOAIVUVIEC, _BIEUMAUID, _DUONGSU_IDS, _ANPHI_ID, _DVCQG_TT_ID, _STYLE_PANEL) {
                            var _hddPageIndex = document.getElementById('<%=hddPageIndex.ClientID%>').value;
                            var link = "/NopAnPhi.aspx?tp_id=" + TUPHAP_ANPHI_ID + "&ma_tb=" + MA_THONGBAO + "&donID=" + _DON_ID + "&dsID=" + _DUONGSU_ID + "&styleCase=" + _MALOAIVUVIEC + "&bmID=" + _BIEUMAUID + "&dsIDS=" + _DUONGSU_IDS + "&ANPHI_ID=" + _ANPHI_ID + "&DVCQG_TT_ID=" + _DVCQG_TT_ID + "&style_panel=" + _STYLE_PANEL + "&hddPageIndex=" + _hddPageIndex;
                            var width = 850;
                            var height = 550;
                            //if (_STYLE_PANEL != '2') {
                            //    height = 750;
                            //}
                            OpenPopupCenter(link, "Nộp án phí", width, height);
                        }
                        function OpenPopupCenter(pageURL, title, w, h) {
                            var left = (screen.width / 2) - (w / 2);
                            var top = (screen.height / 2) - (h / 2);
                            var targetWin = window.open(pageURL, title, 'toolbar=no,scrollbars=yes,resizable=yes,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
                            return targetWin;
                        }
                        function Loadds_tha() {
                            $("#<%= cmdSearch1.ClientID %>").click();
                           <%-- if (document.getElementById('<%=hddSearchStatus.ClientID%>').value == '0') {
                                $("#<%= cmdSearch1.ClientID %>").click();
                            }
                            else {
                                $("#<%= cmdSearch1.ClientID %>").click();
                            }--%>
                        }
                    </script>
                </asp:Panel>
            </div>
        </div>
    </div>
    <style>
        .float_right {
            cursor: pointer;
        }

        .homesearch {
            width: 60%;
        }

        .phantrang {
            margin-top: 50px;
        }

        .CSSTableGenerator ul li {
            line-height: 20px;
        }
    </style>
    <%--<script type="text/javascript">
        function pageLoad(sender, args) {
            $(function () {
                var urldmThiHanAn = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/GetDMThiHanhAn") %>';
                $("[id$=txt_DONVITHIHANHAN]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldmThiHanAn, data: "{ 'q': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) { $("[id$=hddNGDCID]").val(i.item.val); }, minLength: 1
                });

            });
            //--------------chosen-select-deselect
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>--%>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function PopupReport(pageURL, title, w, h) {
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }
    </script>
</asp:Content>
