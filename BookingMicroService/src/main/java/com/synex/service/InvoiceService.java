package com.synex.service;

import java.io.IOException;

import org.apache.tomcat.util.http.fileupload.ByteArrayOutputStream;
import org.springframework.stereotype.Service;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.synex.domain.Booking;

@Service
public class InvoiceService {
	public byte[] generateInvoice(Booking booking) {
		Document document = new Document();
		ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
		
		try {
			PdfWriter.getInstance(document, outputStream);
			document.open();
			addContent(document, booking);
			document.close();
			
			return outputStream.toByteArray();
		} catch (DocumentException e) {
			e.printStackTrace();
		} finally {
			try {
				outputStream.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return null;
	}
	
	private void addContent(Document document, Booking booking) throws DocumentException {
		Font headerFont = new Font(Font.FontFamily.TIMES_ROMAN, 18, Font.BOLD);
		Font regularFont = new Font(Font.FontFamily.TIMES_ROMAN, 12);
		
		Paragraph header = new Paragraph("Invoice", headerFont);
		header.setAlignment(Element.ALIGN_CENTER);
		document.add(header);
		
		document.add(new Paragraph("\n"));
		
		PdfPTable table = new PdfPTable(2);
		table.setWidthPercentage(100);
		table.setWidths(new float[] {1,2});
		
		PdfPCell cell;
		
		cell = new PdfPCell(new Phrase("Invoice Number:", regularFont));
		table.addCell(cell);
		cell = new PdfPCell(new Phrase(String.valueOf(booking.getBookingId()), regularFont));
		table.addCell(cell);
		
		cell = new PdfPCell(new Phrase("Invoice Date:", regularFont));
		table.addCell(cell);
		cell = new PdfPCell(new Phrase(booking.getUserName(), regularFont));
		table.addCell(cell);
		
		cell = new PdfPCell(new Phrase("Customer Name:", regularFont));
		table.addCell(cell);
		cell = new PdfPCell(new Phrase(booking.getUserName(), regularFont));
		table.addCell(cell);
		
		cell = new PdfPCell(new Phrase("Customer Email:", regularFont));
		table.addCell(cell);
		cell = new PdfPCell(new Phrase(booking.getUserEmail(), regularFont));
		table.addCell(cell);
		
		cell = new PdfPCell(new Phrase("Customer Mobile:", regularFont));
		table.addCell(cell);
		cell = new PdfPCell(new Phrase(booking.getCustomerMobile(), regularFont));
		table.addCell(cell);
		
		cell = new PdfPCell(new Phrase("Booking ID:", regularFont));
		table.addCell(cell);
		cell = new PdfPCell(new Phrase(String.valueOf(booking.getBookingId()), regularFont));
		table.addCell(cell);
		
		cell = new PdfPCell(new Phrase("Hotel:", regularFont));
		table.addCell(cell);
		cell = new PdfPCell(new Phrase(booking.getHotelName(), regularFont));
		table.addCell(cell);
		
		cell = new PdfPCell(new Phrase("Room Type:", regularFont));
		table.addCell(cell);
		cell = new PdfPCell(new Phrase(booking.getRoomType(), regularFont));
		table.addCell(cell);
		
		cell = new PdfPCell(new Phrase("Check-In Date:", regularFont));
		table.addCell(cell);
		cell = new PdfPCell(new Phrase(booking.getCheckInDate(), regularFont));
		table.addCell(cell);
		
		cell = new PdfPCell(new Phrase("Check-Out Date:", regularFont));
		table.addCell(cell);
		cell = new PdfPCell(new Phrase(booking.getCheckOutDate(), regularFont));
		table.addCell(cell);
		
		cell = new PdfPCell(new Phrase("No. of Rooms:", regularFont));
		table.addCell(cell);
		cell = new PdfPCell(new Phrase(String.valueOf(booking.getNoRooms()), regularFont));
		table.addCell(cell);
		
		cell = new PdfPCell(new Phrase("Price per Room:", regularFont));
		table.addCell(cell);
		cell = new PdfPCell(new Phrase("$" + booking.getPrice(), regularFont));
		table.addCell(cell);
		
		cell = new PdfPCell(new Phrase("Discount:", regularFont));
		table.addCell(cell);
		cell = new PdfPCell(new Phrase(booking.getDiscount()*100 + "%", regularFont));
		table.addCell(cell);
		
		cell = new PdfPCell(new Phrase("No. of Rooms:", regularFont));
		table.addCell(cell);
		cell = new PdfPCell(new Phrase(String.valueOf(booking.getNoRooms()), regularFont));
		table.addCell(cell);
		
		cell = new PdfPCell(new Phrase("Tax Rate::", regularFont));
		table.addCell(cell);
		cell = new PdfPCell(new Phrase("$" + booking.getTotalSavings(), regularFont));
		table.addCell(cell);

		cell = new PdfPCell(new Phrase("Total Savings:", regularFont));
		table.addCell(cell);
		cell = new PdfPCell(new Phrase("$" + booking.getTotalSavings(), regularFont));
		table.addCell(cell);
		
		document.add(table);
		
		document.add(new Paragraph("\n"));
		
		Paragraph totalSavings = new Paragraph("Total Amount: $" + booking.getFinalCharges(), headerFont);
		totalSavings.setAlignment(Element.ALIGN_RIGHT);
		document.add(totalSavings);
	}
	
	private String getCurrentDate() {
		java.util.Date today = new java.util.Date();
		return today.toString();
	}
}
