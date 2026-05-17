<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="DanhsachKQGQ.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.DanhsachKQGQ" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <style type="text/css">
        .DonGDTCol1 {
            width: 100px;
        }

        .DonGDTCol2 {
            width: 240px;
        }

        .DonGDTCol3 {
            width: 80px;
        }

        .DonGDTCol4 {
            width: 160px;
        }

        .DonGDTCol5 {
            width: 70px;
        }
    </style>
    <asp:HiddenField ID="hddLoaiTK" runat="server" Value="" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tìm kiếm
                                    <asp:LinkButton ID="lbtTTTK" runat="server" Text="[ Nâng cao ]" ForeColor="#0E7EEE" OnClick="lbtTTTK_Click"></asp:LinkButton></h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">

                                        <tr>
                                            <td class="DonGDTCol1">Tòa ra BA/QĐ</td>
                                            <td class="DonGDTCol2">
                                                <asp:DropDownList ID="ddlToaXetXu" CssClass="chosen-select"
                                                    runat="server" Width="230px">
                                                </asp:DropDownList>
                                            </td>
                                            <td class="DonGDTCol3">Số BA/QĐ</td>
                                            <td class="DonGDTCol4">
                                                <asp:TextBox ID="txtSoQDBA" runat="server" CssClass="user" Width="152px" MaxLength="50"></asp:TextBox>
                                            </td>
                                            <td class="DonGDTCol5">Ngày BA/QĐ</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayBAQD" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayBAQD" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayBAQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblTitleBC" runat="server" Text="Nguyên đơn"></asp:Label></td>
                                            <td>
                                                <asp:TextBox ID="txtNguyendon" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox></td>
                                            <td>
                                                <asp:Label ID="lblTitleBD" runat="server" Text="Bị đơn"></asp:Label></td>
                                            <td>
                                                <asp:TextBox ID="txtBidon" runat="server" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox>
                                            </td>
                                            <td>Loại án</td>
                                            <td>
                                                <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select"
                                                    AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiAn_SelectedIndexChanged"
                                                    runat="server" Width="160px">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>

                                        <asp:Panel ID="pnTTTK" runat="server" Visible="false">
                                            <tr>
                                                <td>Số thụ lý</td>
                                                <td>
                                                    <asp:TextBox ID="txtThuly_So" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox></td>
                                                <td>Ngày tạo</td>
                                                <td>
                                                    <asp:TextBox ID="txtThuLy_TuNgay" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtThuLy_TuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtThuLy_TuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                                <td>Đến ngày</td>
                                                <td>
                                                    <asp:TextBox ID="txtThuly_DenNgay" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtThuly_DenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtThuly_DenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Cán bộ giải quyết đơn
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlThamtravien" CssClass="chosen-select" runat="server" Width="230px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>LĐ phụ trách</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlPhoVuTruong" CssClass="chosen-select"
                                                        runat="server" Width="160px"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlPhoVuTruong_SelectedIndexChanged">
                                                    </asp:DropDownList></td>
                                                <td>
                                                    <asp:DropDownList ID="ddlLoaiThamPhan" runat="server" AutoPostBack="true" OnSelectedIndexChanged="Drop_LoaiThamPhan_SelectedIndexChanged">
                                                        <asp:ListItem Text="Tất cả thẩm phán" Value="0" />
                                                        <asp:ListItem Text="Thẩm phán tối cao" Value="1" />
                                                        <asp:ListItem Text="Thẩm phán bậc 3" Value="2" />
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlThamphan"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlThamphan_SelectedIndexChanged"
                                                        CssClass="chosen-select" runat="server" Width="160px">
                                                    </asp:DropDownList></td>
                                            </tr>
                                            <tr>
                                                <td>Kết quả giải quyết</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlKetquaThuLy" CssClass="chosen-select"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlKetquaThuLy_SelectedIndexChanged"
                                                        runat="server" Width="230px">
                                                        <asp:ListItem Value="3" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="4" Text="Chưa có kết quả "></asp:ListItem>
                                                        <asp:ListItem Value="5" Text="Đã có kết quả"></asp:ListItem>
                                                        <asp:ListItem Value="7" Text="Đã có KQ nhưng vẫn còn đơn TLM"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="...Trả lời đơn"></asp:ListItem>
                                                        <%-- <asp:ListItem Value="-1" Text="...Kháng nghị(CA + VKS)"></asp:ListItem>--%>
                                                        <asp:ListItem Value="1" Text="......Kháng nghị (CA)"></asp:ListItem>
                                                        <%-- <asp:ListItem Value="-2" Text="......Kháng nghị (VKS)"></asp:ListItem>--%>
                                                        <asp:ListItem Value="2" Text="...Xếp đơn"></asp:ListItem>
                                                        <asp:ListItem Value="8" Text="...VKS đang giải quyết"></asp:ListItem>
                                                         <asp:ListItem Value="6" Text="...Xử lý khác"></asp:ListItem>

                                                        <asp:ListItem Value="11" Text="...Trả lời đơn + Kháng nghị (CA)"></asp:ListItem>
                                                        <asp:ListItem Value="12" Text="...Trả lời đơn + Xếp đơn"></asp:ListItem>
                                                        <asp:ListItem Value="13" Text="...Trả lời đơn + Xử lý khác"></asp:ListItem>
                                                        <asp:ListItem Value="14" Text="...Kháng nghị (CA) + Xếp đơn"></asp:ListItem>
                                                        <asp:ListItem Value="15" Text="...Kháng nghị (CA) + Xử lý khác"></asp:ListItem>

                                                        <%--  <asp:ListItem Value="10" Text="...Nghiên cứu lại, xác minh, bổ sung"></asp:ListItem>--%>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Án thời hiệu</td>
                                                <td>
                                                    <asp:DropDownList ID="dropAnDB_TH" runat="server"
                                                        Width="160px" CssClass="chosen-select">
                                                        <asp:ListItem Value="" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Đã hết thời hiệu"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Còn thời hiệu dưới một tháng"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Còn thời hiệu dưới hai tháng"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="Còn thời hiệu dưới ba tháng"></asp:ListItem>
                                                    
                                                    </asp:DropDownList></td>
                                                <td></td>
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td>Loại ngày</td>
                                                <td>
                                                    <asp:DropDownList runat="server" ID="dropLoaiNgay"
                                                        Width="230px" CssClass="chosen-select">
                                                        <asp:ListItem Value="0" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Ngày phát hành của vụ"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Ngày phát hành TATC"></asp:ListItem>
                                                    </asp:DropDownList></td>
                                                <td>
                                                    <asp:Label ID="lblTuNgay" runat="server" Text="Từ ngày"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtGQD_TuNgay" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtGQD_TuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtGQD_TuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblDenNgay" runat="server" Text="Đến ngày"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtGQD_DenNgay" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtGQD_DenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtGQD_DenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Kết quả xét xử</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlKetquaXX" CssClass="chosen-select"
                                                        runat="server" Width="230px">
                                                    </asp:DropDownList></td>
                                                <td>Thuộc án</td>
                                                <td>
                                                    <asp:DropDownList ID="dropAnDB"
                                                        AutoPostBack="true" OnSelectedIndexChanged="dropAnDB_SelectedIndexChanged"
                                                        CssClass="chosen-select" runat="server" Width="160px">
                                                        <asp:ListItem Value="0" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Án Quốc hội"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Án Chỉ đạo"></asp:ListItem>
                                                        <%--<asp:ListItem Value="4" Text="Án trao đổi CV"></asp:ListItem>--%>
                                                        <%-- <asp:ListItem Value="3" Text="Án thời hiệu"></asp:ListItem>--%>
                                                    </asp:DropDownList></td>
                                                <td>Thông báo</td>
                                                <td>
                                                    <asp:DropDownList ID="dropTypeTB" Enabled="false"
                                                        CssClass="chosen-select" runat="server" Width="160px">
                                                        <asp:ListItem Value="0" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Chưa có Thông báo TT"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Có Thông báo TT"></asp:ListItem>

                                                        <asp:ListItem Value="3" Text="Chưa có Thông báo KQ"></asp:ListItem>
                                                        <asp:ListItem Value="4" Text="Có Thông báo KQ"></asp:ListItem>

                                                        <asp:ListItem Value="5" Text="Chưa có Thông báo TT & Thông báo KQ"></asp:ListItem>
                                                        <asp:ListItem Value="6" Text="Có Thông báo TT & Thông báo KQ"></asp:ListItem>
                                                    </asp:DropDownList></td>
                                            </tr>
                                            <tr>
                                                <td>Loại BA GĐT</td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlLoaiGDT" CssClass="chosen-select" runat="server" Width="230px">
                                                            <asp:ListItem Value="4" Text="--Tất cả--"></asp:ListItem>
                                                            <asp:ListItem Value="0" Text="Đơn đề nghị GĐT,TT"></asp:ListItem>
                                                            <asp:ListItem Value="5" Text="...Đơn đề nghị GĐT"></asp:ListItem>
                                                            <asp:ListItem Value="6" Text="...Đơn đề nghị TT"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Rút Hồ sơ đoàn kiểm tra"></asp:ListItem>
                                                            <asp:ListItem Value="3" Text="Chủ động GĐT qua Bản án"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="Kháng nghị của VKS"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                            </tr>
                                        </asp:Panel>

                                        <tr>
                                            <td></td>
                                            <td align="left" colspan="3">
                                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="cmdTimkiem_Click" />
                                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                                            </td>
                                            <td align="right" colspan="2"></td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td colspan="5"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="6">
                                                <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">In báo cáo
                                    <asp:LinkButton ID="lkInBC_OpenForm" runat="server" Text="[ Mở ]"
                                        ForeColor="#0E7EEE" OnClick="lkInBC_OpenForm_Click"></asp:LinkButton></h4>
                                <div class="boder" style="padding: 10px;">
                                    <asp:Panel ID="pnInBC" runat="server" Visible="false">
                                        <table class="table1">
                                            <tr>
                                                <td class="DonGDTCol1">Tiêu đề báo cáo</td>
                                                <td>
                                                    <asp:TextBox ID="txtTieuDeBC" runat="server"
                                                        CssClass="user" Width="486px" MaxLength="250" Text="Danh sách các vụ án"></asp:TextBox>
                                                    <asp:Button ID="cmdPrint" runat="server" CssClass="buttoninput"
                                                        Height="26px" Text="In biểu mẫu" OnClick="cmdPrint_Click" />
                                                    <asp:Button ID="cmdPrintBC" runat="server" CssClass="buttoninput"
                                                        Height="26px" Text="DS án Thơi hiệu 3 năm" OnClick="cmdPrintBC_Click" />
                                                     <asp:Button ID="cmdPrintBC5" runat="server" CssClass="buttoninput"
                                                        Height="26px" Text="DS án Thơi hiệu 5 năm" OnClick="cmdPrintBC5_Click" />

                                                </td>
                                            </tr>
                                            <tr style="display: none;">
                                                <td>Mẫu báo cáo</td>
                                                <td>
                                                    <asp:DropDownList ID="dropMauBC" CssClass="chosen-select" runat="server" Width="494px">
                                                        <asp:ListItem Value="4" Text="Mẫu 4: Thống kê vụ án đang trong giai đoạn giải quyết tờ trình"></asp:ListItem>

                                                    </asp:DropDownList>

                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="phantrang">
                                <div class="sobanghi">

                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                    <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so" Visible="false"
                                        AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
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
                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%"
                                OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="STT" HeaderText="TT" HeaderStyle-Width="30px" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Số & Ngày thụ lý</HeaderTemplate>
                                        <ItemTemplate>
                                            
                                            <%#(Eval("LisThuLyDon")+"").Replace(";", ", <br/>")%>
                                            <br style="margin-top: 10px;" />

                                            <asp:LinkButton ID="cmdSoDonTrung" runat="server"
                                                ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Số đơn " + Eval("TONGDON") + "<br/> (" + Eval("cThulymoi")+ " đơn TLM)" %>'
                                                CommandArgument='<%#Eval("ID") %>' CommandName="SoDonTrung"></asp:LinkButton>


                                            <br style="margin-top: 10px;" />

                                            <asp:LinkButton ID="cmdCV81" runat="server" Font-Size="12px"
                                                ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Án Quốc hội"  %>'
                                                CommandArgument='<%#Eval("ID") %>' CommandName="CongVan81"
                                                Visible='<%# (Eval("SoCV81")+"")=="0"?false:true  %>'></asp:LinkButton>
                                            <br style="margin-top: 10px;" />
                                            <asp:LinkButton ID="cmdChidao" runat="server"
                                                Font-Size="12px" ForeColor="#0e7eee" Font-Bold="true"
                                                CommandArgument='<%#Eval("ID") %>' CommandName="CHIDAO"
                                                Visible='<%# (Eval("arrCHIDAOID")+"")==""?false:true  %>' Text='<%# "Án chỉ đạo"  %>'></asp:LinkButton>

                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thông tin bản án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("InforBA")%>
                                           <%-- <b><%#Eval("SOANPHUCTHAM")%></b>
                                            <br />
                                            <%#Eval("NGAYXUPHUCTHAM")%>
                                            <br />
                                            <%#Eval("TOAXX_VietTat")%>--%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="QHPLDN" HeaderText="Quan hệ pháp luật" HeaderStyle-Width="60px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGUYENDON" HeaderText="Nguyên đơn/ Người khởi kiện" HeaderStyle-Width="70px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="BIDON" HeaderText="Bị đơn/ Người bị kiện" HeaderStyle-Width="70px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGUOIKHIEUNAI" HeaderText="Người đề nghị" HeaderStyle-Width="90px"></asp:BoundColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="150px" ItemStyle-HorizontalAlign="Justify" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Thẩm tra viên<br />
                                            Lãnh đạo Vụ<br />
                                            Thẩm phán
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="lttTTV" runat="server"></asp:Literal> <br />
                                            <%--<%# String.IsNullOrEmpty(Eval("TENTHAMTRAVIEN")+"")? "":("TTV:<b style='margin-left:3px;'>"+Eval("TENTHAMTRAVIEN")+"</b><br />")%>--%>
                                            <%# String.IsNullOrEmpty(Eval("TENLANHDAO")+"")? "":( Eval("MaChucVuLD") + ":<b style='margin-left:3px;'>"+Eval("TENLANHDAO")+"</b><br />")%>
                                            <%# String.IsNullOrEmpty(Eval("TENTHAMPHAN")+"")? "":("TP:<b style='margin-left:3px;'>"+Eval("TENTHAMPHAN")+"</b>")%>
                                            <%# String.IsNullOrEmpty(Eval("THAMPHANTC_TEN")+"")? "":("TPTC:<b style='margin-left:3px;'>"+Eval("THAMPHANTC_TEN")+"</b><br/>")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Trạng thái</HeaderTemplate>
                                        <ItemTemplate>
                                            <b>
                                                <asp:Literal ID="lttLanTT" runat="server"></asp:Literal></b>
                                            <br />
                                            <asp:Literal ID="lttDetaiTinhTrang" runat="server"></asp:Literal>
                                            <asp:Literal ID="lttKQGQ" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thao tác</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Panel ID="pnthongbao" runat="server" Visible='<%# Convert.ToInt16(Eval("SoCV81")+"")==1 ? true:false  %>'>
                                                <asp:LinkButton ID="lkThongBaoTT" runat="server" Text="Thông báo TT"
                                                    Font-Bold="true" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>' CommandName="ThongBaoTT"></asp:LinkButton>
                                                <br />
                                            </asp:Panel>
                                            <asp:LinkButton ID="cmdKetqua" runat="server" Font-Bold="true"
                                                ForeColor="#0e7eee" CommandArgument='<%# Eval("ID") +"#"+ Convert.ToInt16( Eval("LOAIAN")) %>'
                                                CommandName="KETQUA" Text="Kết quả giải quyết"></asp:LinkButton>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                            <asp:DataGrid ID="gridHS" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%"
                                OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="STT" HeaderText="TT" HeaderStyle-Width="30px" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Số & Ngày thụ lý</HeaderTemplate>
                                        <ItemTemplate>
                                                                                   
                                            <%#(Eval("LisThuLyDon")+"").Replace(";", ", <br/>")%>
                                            <br style="margin-top: 10px;" />

                                            <asp:LinkButton ID="cmdSoDonTrung" runat="server"
                                                ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Số đơn " + Eval("TONGDON") + "<br/> (" + Eval("cThulymoi")+ " đơn TLM)" %>'
                                                CommandArgument='<%#Eval("ID") %>' CommandName="SoDonTrung"></asp:LinkButton>


                                            <asp:LinkButton ID="cmdCV81" runat="server" Font-Size="12px"
                                                ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Án Quốc hội"  %>'
                                                CommandArgument='<%#Eval("ID") %>' CommandName="CongVan81"
                                                Visible='<%# (Eval("SoCV81")+"")=="0"?false:true  %>'></asp:LinkButton>
                                            <br style="margin-top: 10px;" />
                                            <asp:LinkButton ID="cmdChidao" runat="server"
                                                Font-Size="12px" ForeColor="#0e7eee" Font-Bold="true"
                                                CommandArgument='<%#Eval("ID") %>' CommandName="CHIDAO"
                                                Visible='<%# (Eval("arrCHIDAOID")+"")==""?false:true  %>' Text='<%# "Án chỉ đạo"  %>'></asp:LinkButton>

                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thông tin bản án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("InforBA")%>
                                            <%--<b><%#Eval("SOANPHUCTHAM")%></b>
                                            <br />
                                            <%#Eval("NGAYXUPHUCTHAM")%>
                                            <br />
                                            <%#Eval("TOAXX_VietTat")%>--%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="QHPLDN" HeaderText="Tội danh" HeaderStyle-Width="120px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGUYENDON" HeaderText="Bị cáo đầu vụ" HeaderStyle-Width="70px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="BIDON" HeaderText="Bị cáo khiếu nại" HeaderStyle-Width="70px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGUOIKHIEUNAI" HeaderText="Người đề nghị" HeaderStyle-Width="90px"></asp:BoundColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="150px" ItemStyle-HorizontalAlign="Justify" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Thẩm tra viên<br />
                                            Lãnh đạo Vụ<br />
                                            Thẩm phán
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="lttTTV" runat="server"></asp:Literal> <br />
                                            <%--<%# String.IsNullOrEmpty(Eval("TENTHAMTRAVIEN")+"")? "":("TTV:<b style='margin-left:3px;'>"+Eval("TENTHAMTRAVIEN")+"</b><br />")%>--%>
                                            <%# String.IsNullOrEmpty(Eval("TENLANHDAO")+"")? "":( Eval("MaChucVuLD") + ":<b style='margin-left:3px;'>"+Eval("TENLANHDAO")+"</b><br />")%>
                                            <%# String.IsNullOrEmpty(Eval("TENTHAMPHAN")+"")? "":("TP:<b style='margin-left:3px;'>"+Eval("TENTHAMPHAN")+"</b>")%>
                                            <%# String.IsNullOrEmpty(Eval("THAMPHANTC_TEN")+"")? "":("TPTC:<b style='margin-left:3px;'>"+Eval("THAMPHANTC_TEN")+"</b><br/>")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Trạng thái</HeaderTemplate>
                                        <ItemTemplate>
                                            <b>
                                                <asp:Literal ID="lttLanTT" runat="server"></asp:Literal></b>
                                            <br />
                                            <asp:Literal ID="lttDetaiTinhTrang" runat="server"></asp:Literal>
                                            <asp:Literal ID="lttKQGQ" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thao tác</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Panel ID="pnthongbao" runat="server" Visible='<%# Convert.ToInt16(Eval("SoCV81")+"")==1 ? true:false  %>'>
                                                <asp:LinkButton ID="lkThongBaoTT" runat="server" Text="Thông báo TT"
                                                    Font-Bold="true" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>' CommandName="ThongBaoTT"></asp:LinkButton>
                                                <br />
                                            </asp:Panel>
                                            <asp:LinkButton ID="cmdKetqua" runat="server" Font-Bold="true"
                                                ForeColor="#0e7eee" CommandArgument='<%# Eval("ID") +"#"+ Convert.ToInt16( Eval("LOAIAN")) %>'
                                                CommandName="KETQUA" Text="Kết quả giải quyết"></asp:LinkButton>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                    <asp:DropDownList ID="ddlPageCount2" runat="server" Width="55px" CssClass="so" Visible="false" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
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
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function LoadDsDon() {
            $("#<%= cmdTimkiem.ClientID %>").click();
        }
        
        function PopupReport(pageURL, title, w, h) {
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }

    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>

</asp:Content>
